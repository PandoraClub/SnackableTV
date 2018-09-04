//
//  STMediaProcessor.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-25.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import CoreData

protocol STMediaProcessorType: ACSyncableProcessorType {
    func fetchStoreMedias(byPath path: String, relationshipId: Int64?, _ completion: @escaping (_ success: Bool, _ syncedObject: Any?) -> ())
}

@objc class STMediaProcessor: NSObject, STMediaProcessorType {
    let syncContext: ACSyncContext
    
    required init (context: ACSyncContext) {
        self.syncContext = context
    }
    
    lazy var mediaRemote: STMediaRemoteType = {
        return STMediaRemote(remoteSession: self.syncContext.remoteSession)
    }()
    
    func sync(_ completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: Error?) -> ()) {
    }
    
    
    func fetchStoreMedias(byPath path: String, relationshipId: Int64?, _ completion: @escaping (_ success: Bool, _ syncedObject: Any?) -> ()) {
        self.mediaRemote.fetchMedias(byPath: path) { (mediasResult) in
            guard mediasResult.isSuccess,
                let medias = mediasResult.value?.items else
            {
                completion(false, nil)
                return
            }
            
            if let rid = relationshipId {
                medias.forEach({ $0.relationshipId = rid })
                _ = self.clearRelationships(onManagedObjectType: STCollection.self, ofIds: [rid], relationshipName: "medias")
            }
            _ = self.store(medias, toManagedObjectType: STMedia.self)
            
            completion(true, medias)
        }
    }
}
