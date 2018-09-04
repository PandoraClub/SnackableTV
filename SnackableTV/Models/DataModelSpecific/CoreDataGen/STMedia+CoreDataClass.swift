//
//  STMedia+CoreDataClass.swift
//  
//
//  Created by Austin Chen on 2017-04-25.
//
//

import Foundation
import CoreData

@objc(STMedia)
public class STMedia: ACBase {
    
    override func saveSyncableProperties(fromSyncable syncable: ACRemoteRecordSyncableType) {
        guard let rRecord = syncable as? STJsonMedia else {
            return
        }
        
        self.name = rRecord.name
        self.desc = rRecord.desc
        self.shortDesc = rRecord.shortDesc
        self.type = rRecord.type
        self.genres = rRecord.genres
        self.images = rRecord.images
        
        guard let context = self.managedObjectContext
            else { return }
        /*
         if let rId = rRecord.seasonId {
         self.addToOneRelationship(STCollection.self, relationshipName: "collection", foreignKey: rId, context: context)
         }*/
        
        if let rId = rRecord.relationshipId { // assume parent collection relationshipId
            self.addToManyRelationship(STCollection.self, relationshipName: "collections", foreignKey: rId, context: context)
        }
    }
}
