//
//  STContentProcessor.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-11.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import CoreData

protocol STContentProcessorType: ACSyncableProcessorType {
    func fetchStoreContents(byPath path: String, params: String?, relationshipId: Int64?, _ completion: @escaping (_ success: Bool, _ syncedObject: Any?) -> ())
}

extension STContentProcessorType {
    func fetchStoreContents(byPath path: String, params: String? = nil, relationshipId: Int64?, _ completion: @escaping (_ success: Bool, _ syncedObject: Any?) -> ()) {
        return fetchStoreContents(byPath: path, params: params, relationshipId: relationshipId, completion)
    }
}

@objc class STContentProcessor: NSObject, STContentProcessorType {
    let syncContext: ACSyncContext
    
    required init (context: ACSyncContext) {
        self.syncContext = context
    }
    
    lazy var contentRemote: STContentRemoteType = {
        return STContentRemote(remoteSession: self.syncContext.remoteSession)
    }()
    
    lazy var contentPackageRemote: STContentPackageRemoteType = {
        return STContentPackageRemote(remoteSession: self.syncContext.remoteSession)
    }()
    
    func sync(_ completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: Error?) -> ()) {
    }

    func fetchStoreContents(byPath path: String, params: String?, relationshipId: Int64?, _ completion: @escaping (_ success: Bool, _ syncedObject: Any?) -> ()) {
        self.contentRemote.fetchContents(byPath: path, params: params, { (contentsResult) in
            guard contentsResult.isSuccess,
                let contents = contentsResult.value?.items else
            {
                completion(false, nil)
                return
            }
            
            if let rid = relationshipId {
                contents.forEach({ $0.relationshipId = relationshipId })
                _ = self.clearRelationships(onManagedObjectType: STCollection.self, ofIds: [rid], relationshipName: "contents")
            }
            _ = self.store(contents, toManagedObjectType: STContent.self)
            completion(true, contents)
            
            // remove batch fetching contentPackages, only fetch content package when about to play a video.  
            /*
            let dispatchGroup = DispatchGroup()
            // fetch content package
            contents.forEach({ content in
                guard let cp = content.contentPackages?.first
                    else { return }
                
                dispatchGroup.enter()
                let cpPath = path + "/contents/\(content.id)/contentPackages/\(cp.id)"
                self.contentPackageRemote.fetchContentPackage(byPath: cpPath, { (contentPackageResult) in
                    guard contentPackageResult.isSuccess,
                        let contentPackage = contentPackageResult.value else
                    {
                        dispatchGroup.leave()
                        return
                    }
                    
                    _ = self.store([contentPackage], toManagedObjectType: STContentPackage.self)
                    dispatchGroup.leave()
                })
            })
            
            dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                completion(true, contents)
            })
            */
        })
    }
}
