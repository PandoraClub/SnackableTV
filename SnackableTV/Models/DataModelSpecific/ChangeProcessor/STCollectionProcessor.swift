//
//  STCollectionProcessor.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-05.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import CoreData

protocol STCollectionProcessorType: ACSyncableProcessorType {
}

@objc class STCollectionProcessor: NSObject, STCollectionProcessorType {
    
    let syncContext: ACSyncContext
    
    required init (context: ACSyncContext) {
        self.syncContext = context
    }
    
    lazy var collectionRemote: STCollectionRemoteType = {
        return STCollectionRemote(remoteSession: self.syncContext.remoteSession)
    }()
    
    lazy var contentRemote: STContentRemoteType = {
        return STContentRemote(remoteSession: self.syncContext.remoteSession)
    }()
    
    lazy var contentProcessor: STContentProcessorType = {
        return STContentProcessor(context: self.syncContext)
    }()
    
    lazy var mediaProcessor: STMediaProcessorType = {
        return STMediaProcessor(context: self.syncContext)
    }()
    
    func sync(_ completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: Error?) -> ()) {
        self.fetchAndStoreRootCollections { (success, synced) in
            guard let syncedItems = synced as? STJsonItems<STJsonCollection>,
                let jsonCollections = syncedItems.items
                else
            {
                completion(false, nil, nil)
                return
            }
            let resultCompletion: (_ success: Bool) -> Void = { (success) in
                DispatchQueue.main.async(execute: {
                    completion(true, jsonCollections, nil)
                })
            }
            
            let dispatchGroup = DispatchGroup()
            jsonCollections.forEach{ jsonCollection in
                guard jsonCollection.itemsType ~= "Collection"
                    else { return }
                
                dispatchGroup.enter()
                // fetchAndStoreChildCollection
                let path = "/collections/" + jsonCollection.id.toString
                self.fetchStoreCollections(byPath: path, relationshipId: jsonCollection.id, { (success, subSynced) in
                    guard let subSyncedItems = subSynced as? STJsonItems<STJsonCollection>,
                        let jsonSubCollections = subSyncedItems.items
                        else { dispatchGroup.leave(); return }
                    
                    let dispatchGroup2 = DispatchGroup()
                    jsonSubCollections.forEach{ subCollection in
                        if subCollection.itemsType ~= "Media" { // Series
                            dispatchGroup2.enter()
                            let path = "/collections/" + subCollection.id.toString
                            self.mediaProcessor.fetchStoreMedias(byPath: path, relationshipId: subCollection.id, { (success, synced) in
                                dispatchGroup2.leave()
                            })
                        } else if subCollection.itemsType ~= "Content" {
                            dispatchGroup2.enter()
                            let path = "/collections/" + subCollection.id.toString
                            self.contentProcessor.fetchStoreContents(byPath: path, relationshipId: subCollection.id, { (success, synced) in
                                dispatchGroup2.leave()
                            })
                        }
                    }
                    dispatchGroup2.notify(queue: DispatchQueue.main, execute: {
                        dispatchGroup.leave()
                    })
                })
            }
            dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                resultCompletion(true)
            })
        }
    }

    func fetchAndStoreRootCollections(_ completion: @escaping (_ success: Bool, _ synced: Any?) -> ()) {
        self.collectionRemote.fetchCollections(byPath: "") { (collectionsResult) in
            let resultCompletion: (_ success: Bool) -> Void = { (success) in
                DispatchQueue.main.async(execute: {
                    completion(true, collectionsResult.value)
                })
            }
            guard collectionsResult.isSuccess,
                var collections = collectionsResult.value?.items else {
                    resultCompletion(false)
                    return
            }
            
            // per Jeff Langille's email, May 15, 2017 at 11:42:02 AM EDT
            collections = collections.filter {
                $0.id == 1704 || $0.id == 1717
            }
            _ = self.store(collections, toManagedObjectType: STCollection.self)
            
            resultCompletion(true)
        }
    }

    func fetchStoreCollections(byPath path: String, relationshipId: Int64? = nil, _ completion: @escaping (_ success: Bool, _ synced: Any?) -> ()) {
        self.collectionRemote.fetchCollections(byPath: path) { (collectionsResult) in
            let resultCompletion: (_ success: Bool) -> Void = { (success) in
                DispatchQueue.main.async(execute: {
                    completion(true, collectionsResult.value)
                })
            }
            guard collectionsResult.isSuccess,
                let collections = collectionsResult.value?.items else {
                resultCompletion(false)
                return
            }
            
            if let rid = relationshipId {
                for (idx, collection) in collections.enumerated() {
                    collection.order = idx
                    collection.relationshipId = relationshipId // injecting relationship ids
                }
                _ = self.clearRelationships(onManagedObjectType: STCollection.self, ofIds: [rid], relationshipName: "childCollections")
            }
            _ = self.store(collections, toManagedObjectType: STCollection.self)
            
            resultCompletion(true)
        }
    }
}


fileprivate let kRemoteFetchSizeDefault: Int = 16
