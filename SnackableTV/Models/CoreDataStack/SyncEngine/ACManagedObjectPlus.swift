//
//  ACManagedObjectPlus.swift
//  <?>App
//
//  Created by Austin Chen on 2016-05-19.
//

import Foundation
import CoreData

// update this alias if base managed object changes
typealias ACManagedObject = ACBase

protocol ACManagedObjectType {
    static func insertItem<T: ACManagedObject>(byID id: Int64, context: NSManagedObjectContext) -> T
    static func removeItem<T: ACManagedObject>(ofType type: T.Type, byID id: String, context: NSManagedObjectContext)
    static func removeByObjectID(_ objectID: NSManagedObjectID, context: NSManagedObjectContext)
    
    func saveSyncableProperties(fromSyncable syncable: ACRemoteRecordSyncableType)
}

extension ACManagedObject: ACManagedObjectType {
    // Insert code here to add functionality to your managed object subclass
    static func insertItem<T: ACManagedObject>(byID id: Int64, context: NSManagedObjectContext) -> T {
        let item:T = NSManagedObject.insertObject(byContext: context)
        item.id = id
        return item
    }

    // more expensive than delete by ManagedObjectID
    static func removeItem<T: ACManagedObject>(ofType type: T.Type, byID id: String, context: NSManagedObjectContext) {
        let entityName = String(describing: type)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "itemID == %@", id)
        fetchRequest.fetchLimit = 1
        let fetchedObjects:[T] = try! context.fetch(fetchRequest) as! [T]
        if let object = fetchedObjects.first {
            context.delete(object)
        }
    }
    
    static func removeByObjectID(_ objectID: NSManagedObjectID, context: NSManagedObjectContext) {
        let object = context.object(with: objectID)
        context.delete(object)
    }
}

extension NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    class func insertObject<T: NSManagedObject>(byContext context: NSManagedObjectContext) -> T {
        let entityName = String(describing: T.self)
        let object:T = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! T
        return object
    }
    
    // update managedObject by its keyValue pairs
    func updateByKeyValuePairs(_ keyValuePairs: [ACSyncableKeyValuePairType]) -> Void {
        for (managedObjectkey, managedObjectValue) in keyValuePairs {
            guard let _ = self.entity.propertiesByName[managedObjectkey] else {
                continue // remote key may not exist in local data schema
            }
            
            if (managedObjectValue is NSNull) {
                self.setNilValueForKey(managedObjectkey)
            } else {
                self.setValue(managedObjectValue, forKey: managedObjectkey)
            }
        }
    }

    // so that tables that does not have its own unique id can still use it
    /**
     add self as the one-to-one, or one of the many-to-one relationships to the relationshipEntityType
     
     - parameter relationshipEntityType: NSManagedObject's type
     - parameter relationshipName:       self's relationship property name to the foreign relation
     - parameter foreignKeyName:         foreign entity's primarykey name string
     - parameter foreignKey:             foreign entity's primarykey
     - parameter context:                managed object context
     */
    func addToOneRelationship<S: ACManagedObject>(_ relationshipEntityType: S.Type, relationshipName: String, foreignKeyName: String = "id", foreignKey: Int64,
                              context: NSManagedObjectContext) {
        let entityName = String(describing: relationshipEntityType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(foreignKeyName) == \(foreignKey)")
        fetchRequest.fetchLimit = 1
        
        let fetchedObjects:[NSManagedObject]
        fetchedObjects = try! context.fetch(fetchRequest) as! [NSManagedObject]
        if let relationshipObject = fetchedObjects.first as? ACManagedObject {
            self.setValue(relationshipObject, forKey: relationshipName)
        }
    }
    
    /**
     add self as the one-to-many, or one of the many-to-many relationships to the relationshipEntityType
     
     - parameter relationshipEntityType: NSManagedObject's type
     - parameter relationshipName:       self's relationship property name to the foreign relation
     - parameter foreignKeyName:         foreign entity's primarykey name string
     - parameter foreignKey:             foreign entity's primarykey
     - parameter context:                managed object context
     */
    func addToManyRelationship<S: ACManagedObject>(_ relationshipEntityType: S.Type, relationshipName: String, foreignKeyName: String = "id", foreignKey: Int64, context: NSManagedObjectContext) {
        
        let entityName = String(describing: relationshipEntityType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(foreignKeyName) == \(foreignKey)")
        
        let fetchedObjects:[NSManagedObject]
        fetchedObjects = try! context.fetch(fetchRequest) as! [NSManagedObject]
        
        let mutableOrderSet = self.mutableOrderedSetValue(forKey: relationshipName)
        for foreignObject in fetchedObjects {
            mutableOrderSet.add(foreignObject)
        }
    }

}

extension NSManagedObjectContext {
    
    func findFirst<T: NSManagedObject>(withPredicate predicate:NSPredicate, onType type: T.Type) -> T? {
        let entityName = String(describing: type)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        let fetchedObjects:[T] = try! self.fetch(fetchRequest) as! [T]
        return fetchedObjects.first
    }
    
    /**
     Insert or update mechanism recommended by Apple Doc to minimize the amount of database retrieval. Note: local records not existed remotely are not removed.
     
     - parameter items:     array of PMRemoteRecordSyncable type, remote records to be synced locally
     - parameter type:      managed object entity type
     - parameter uniqueKey: managed object unique id
     
     - returns: array of ACRemoteRecordChange type, with which client code can further decided to modify the properties or saving
     
     eg:
     remote: 3, 4, 7, 9, f, g, u
     
     local : 4, 9, a, g, w
     
     1. both indexes point to the beginning of each array
     2. 3 < 4, so insert and increment remoteIndex
     3. 4 == 4, so update, and increment both indexes
     4. 7 < 9, insert and increment remoteIndex
     5. 9 == 9, update and increment both indexes
     6. f > a, remove a, increment localIndex
     7. f < g, insert and increment remoteIndex
     8. g == g, update and increment both
     9. u < w, insert and increment remoteIndex
     10.still local items left, so remove and increment localIndex
     
     */
    func findOrInsert<T: ACRemoteRecordSyncableType, S: ACManagedObject>(_ items: [T],
                        toManagedObjectType type: S.Type,
                        byUniqueKey uniqueKey: String = "itemID",
                        removeLocalItemsIfNotFoundInRemote shouldRemove: Bool = false) -> [ACRemoteRecordChange<T>] {
        
        let sortedRemoteRecords: [T] = items.sorted(by: { (item1: T, item2: T) -> Bool in
            let key1 = item1.id
            let key2 = item2.id
            return key1 < key2
        })
        let sortedRRIds: [Int64] = sortedRemoteRecords.map({$0.id})
        
        let entityName = String(describing: type)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(uniqueKey) IN %@", sortedRRIds)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "\(uniqueKey)", ascending: true)]
        let localObjects:[NSManagedObject] = try! self.fetch(fetchRequest) as! [NSManagedObject]
        
        var results:[ACRemoteRecordChange<T>] = []
        var remoteIndex = 0
        var localIndex = 0
        
        // insert, update, or remove according to eg 1 to 9
        while remoteIndex < sortedRemoteRecords.count {
            let remoteRecord = sortedRemoteRecords[remoteIndex]
            let itemKey = remoteRecord.id
            
            if (localIndex < localObjects.count) {
                guard let localItemKey = localObjects[localIndex].value(forKey: uniqueKey) as? Int64 else {
                    print ("error: local item does not have key")
                    continue
                }
                
                if (itemKey < localItemKey) {
                    // insert
                    let insertedItem: S = S.insertItem(byID: itemKey, context: self)
                    results.append(ACRemoteRecordChange.inserted(remoteRecord, insertedItem.objectID))
                    remoteIndex += 1
                } else if (itemKey == localItemKey) {
                    // update
                    results.append(ACRemoteRecordChange.found(remoteRecord, localObjects[localIndex].objectID))
                    remoteIndex += 1
                    localIndex += 1 // remote obj index has caught up with the local index, so increment 1
                } else {
                    // remove local
                    if (shouldRemove) {
                        S.removeByObjectID(localObjects[localIndex].objectID, context: self)
                        results.append(ACRemoteRecordChange.removed)
                    }
                    localIndex += 1 // label as Remove and increment 1
                }
            } else {
                // insert - no more local object to for remote objects to compare to
                let insertedItem: S = S.insertItem(byID: itemKey, context: self)
                results.append(ACRemoteRecordChange.inserted(remoteRecord, insertedItem.objectID))
                remoteIndex += 1
            }
        }
        
        // remove according to eg 10
        while localIndex < localObjects.count {
            // remove local
            if (shouldRemove) {
                S.removeByObjectID(localObjects[localIndex].objectID, context: self)
                results.append(ACRemoteRecordChange.removed)
            }
            localIndex += 1 // label as Remove and increment 1
        }
        
        return results
    }

    func removeAll<T: NSManagedObject>(managedObjectType type: T.Type) throws {
        let entityName = String(describing: type)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest) // Todo: only available iOS 9.0 or newer
        do {
            try self.persistentStoreCoordinator?.execute(deleteRequest, with: self)
        } catch let e {
            log(error: e.localizedDescription)
        }
    }
}
