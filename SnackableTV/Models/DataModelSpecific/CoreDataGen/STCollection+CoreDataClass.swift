//
//  STCollection+CoreDataClass.swift
//  
//
//  Created by Austin Chen on 2017-04-06.
//
//

import Foundation
import CoreData

@objc(STCollection)
public class STCollection: ACBase {

    override func saveSyncableProperties(fromSyncable syncable: ACRemoteRecordSyncableType) {
        guard let rRecord = syncable as? STJsonCollection else {
            return
        }
        
        self.order = rRecord.order
        self.name = rRecord.name
        self.desc = rRecord.desc
        self.isAutoGen = rRecord.isAutoGen ?? false
        self.itemsType = rRecord.itemsType
        
        if let rId = rRecord.relationshipId,
            let context = self.managedObjectContext {
            self.addToOneRelationship(STCollection.self, relationshipName: "parentCollection", foreignKey: rId, context: context)
        }
    }
}
