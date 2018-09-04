//
//  STSeason+CoreDataClass.swift
//  
//
//  Created by Austin Chen on 2017-04-26.
//
//

import Foundation
import CoreData

@objc(STSeason)
public class STSeason: ACBase {

    override func saveSyncableProperties(fromSyncable syncable: ACRemoteRecordSyncableType) {
        guard let rRecord = syncable as? STJsonSeason else {
            return
        }
        
        self.name = rRecord.name
        self.number = rRecord.number as NSNumber?
        self.images = rRecord.images
        
        if let mId = rRecord.mediaId,
            let context = self.managedObjectContext {
            self.addToOneRelationship(STMedia.self, relationshipName: "media", foreignKey: mId, context: context)
        }
    }
}
