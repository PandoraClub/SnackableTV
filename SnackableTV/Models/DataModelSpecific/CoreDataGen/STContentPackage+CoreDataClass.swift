//
//  STContentPackage+CoreDataClass.swift
//  
//
//  Created by Austin Chen on 2017-04-06.
//
//

import Foundation
import CoreData

@objc(STContentPackage)
public class STContentPackage: ACBase {
 
    override func saveSyncableProperties(fromSyncable syncable: ACRemoteRecordSyncableType) {
        guard let rRecord = syncable as? STJsonContentPackage else {
            return
        }
        
        self.name = rRecord.name
        self.desc = rRecord.desc
        self.scheduleStart = rRecord.scheduleStartDateTime
        self.scheduleEnd = rRecord.scheduleEndDateTime
        self.images = rRecord.images
        self.duration = rRecord.duration as NSNumber?
        self.securityType = rRecord.securityType
        
        if let cId = rRecord.contentId,
            let context = self.managedObjectContext {
            self.contentId = cId
            self.addToOneRelationship(STContent.self, relationshipName: "content", foreignKey: cId, context: context)
        }
    }
}
