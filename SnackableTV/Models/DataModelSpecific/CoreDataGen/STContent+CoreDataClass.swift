//
//  STContent+CoreDataClass.swift
//  
//
//  Created by Austin Chen on 2017-04-06.
//
//

import Foundation
import CoreData

@objc(STContent)
public class STContent: ACBase {
    
    override func saveSyncableProperties(fromSyncable syncable: ACRemoteRecordSyncableType) {
        guard let rRecord = syncable as? STJsonContent else {
            return
        }
        
        self.name = rRecord.name
        self.desc = rRecord.desc
        self.shortDesc = rRecord.shortDesc
        self.type = rRecord.type
        self.genres = rRecord.genres
        self.images = rRecord.images
        self.agvotCode = rRecord.agvotCode
        self.qfrCode = rRecord.qfrCode
        self.episode = rRecord.episode ?? -1
        self.broadcastDateTime = rRecord.broadcastDateTime
        self.contentPackages = rRecord.contentPackages
        
        guard let context = self.managedObjectContext
            else { return }
        /*
        if let rId = rRecord.seasonId {
            self.addToOneRelationship(STCollection.self, relationshipName: "collection", foreignKey: rId, context: context)
        }*/
        
        if let rId = rRecord.mediaId {
            self.addToOneRelationship(STMedia.self, relationshipName: "media", foreignKey: rId, context: context)
        }
        
        if let rId = rRecord.relationshipId { // assume parent collection relationshipId
            self.addToManyRelationship(STCollection.self, relationshipName: "collections", foreignKey: rId, context: context)
        }
    }
}
