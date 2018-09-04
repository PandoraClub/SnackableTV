//
//  ACChangeProcessor.swift
//  <?>App
//
//  Created by Austin Chen on 2016-04-26.
//

import CoreData

protocol ACSyncableProcessorType {
    var syncContext: ACSyncContext {get}
    
    init (context: ACSyncContext)
    func sync(_ completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: Error?) -> ())
}

extension ACSyncableProcessorType {
    
    func clearRelationships<S: ACManagedObject>(onManagedObjectType type: S.Type, ofIds ids: [Int64],
                            byUniqueKey uniqueKey: String = "id",
                            relationshipName: String) -> Bool
    {
        guard let managedObjectContext = syncContext.managedObjectContext else {
            return false
        }
        
        managedObjectContext.performAndWait({
            let entityName = String(describing: type)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "\(uniqueKey) IN %@", ids)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "\(uniqueKey)", ascending: true)]
            let localObjects:[NSManagedObject] = try! managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            if let relationshipObj = localObjects.first {
                relationshipObj.mutableOrderedSetValue(forKey: relationshipName).removeAllObjects()
            }
            
            if (managedObjectContext.hasChanges) {
                try! managedObjectContext.save() // TODO: for production, change try! to catch
            }
        })
        
        return true
    }
    
    func store<T: ACRemoteRecordSyncableType, S: ACManagedObject>(_ items: [T], toManagedObjectType type: S.Type) -> Bool {
        guard let managedObjectContext = syncContext.managedObjectContext else {
            return false
        }
        
        managedObjectContext.performAndWait({
            let updateData: (ACRemoteRecordSyncableType, NSManagedObjectID) -> Void = { (remoteRecord, managedObjectID) in
                guard let object = managedObjectContext.object(with: managedObjectID) as? S,
                    let rRecord = remoteRecord as? T else
                {
                    return
                }
                object.saveSyncableProperties(fromSyncable: rRecord)
            }
            
            let changes : [ACRemoteRecordChange<T>] = managedObjectContext.findOrInsert(items, toManagedObjectType: S.self, byUniqueKey: "id",
                                                                                        removeLocalItemsIfNotFoundInRemote: true)
            for change in changes {
                switch change {
                case .found(let remoteRecord, let managedObjectID):
                    updateData(remoteRecord, managedObjectID)
                    break
                case .inserted(let remoteRecord, let managedObjectID):
                    updateData(remoteRecord, managedObjectID)
                    break
                default:
                    break
                }
            }
            
            if (managedObjectContext.hasChanges) {
                try! managedObjectContext.save() // TODO: for production, change try! to catch
            }
        })
        
        return true
    }
}
