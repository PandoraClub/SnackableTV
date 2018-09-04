//
//  ACSyncCoordinator.swift
//  <?>App
//
//  Created by Austin Chen on 2016-04-28.
//

import Foundation
import CoreData
import UIKit

let ACSyncAllCompletedNotification = "kACSyncAllCompletedNotification"

protocol ACSyncCoordinatorType  {
    func syncAll(_ completion: @escaping (_ success: Bool, _ synced: [Any]?, _ error: Error?) -> ())
}

open class ACSyncCoordinator: NSObject, ACSyncCoordinatorType {
    
    let syncGroup: DispatchGroup = DispatchGroup()
    var didSetup: Bool = false
    
    var syncContext: ACSyncContext = ACSyncContext()
    var appTerminateObserver: AnyObject? = nil
    
    fileprivate var observerTokens: [NSObjectProtocol] = [] //< The tokens registered with NSNotificationCenter
    
    // MARK - life cycle methods
    
    init(remoteSession: ACRemoteSession) {
        super.init()
        
        self.registerValueTransformers()
        self.syncContext = ACSyncContext(remoteSession: remoteSession,
                                         managedObjectContext: self.coreDataStack.syncManagedObjectContext)
        self.didSetup = true
        self.setupContexts()
        
        appTerminateObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillTerminate, object: nil, queue: nil, using: { (notification) in
            do {
                try self.syncContext.managedObjectContext!.save()
            } catch let e {
                log(error: e.localizedDescription)
            }
        })
    }
    
    convenience init(remoteSession: ACRemoteSession, managedObjectContext: NSManagedObjectContext) {
        self.init(remoteSession: remoteSession)
        self.syncContext = ACSyncContext(remoteSession: remoteSession, managedObjectContext: managedObjectContext)
    }
    
    deinit {
        if let observer = appTerminateObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // MARK - instance methods
    
    lazy var coreDataStack: ACCoreDataStackType = {
        return ACCoreDataStack()
    }()
    
    lazy var collectionProcessor: STCollectionProcessorType = {
        return STCollectionProcessor(context: self.syncContext)
    }()
   
    lazy var contentProcessor: STContentProcessorType = {
        return STContentProcessor(context: self.syncContext)
    }()
    
    lazy var contentPackageProcessor: STContentPackageProcessorType = {
        return STContentPackageProcessor(context: self.syncContext)
    }()
    
    lazy var watchHistoryProcessor: STWatchHistoryProcessorType = {
        return STWatchHistoryProcessor(context: self.syncContext)
    }()
    
    func syncAll(_ completion: @escaping (_ success: Bool, _ synced: [Any]?, _ error: Error?) -> ()) {
        self.collectionProcessor.sync { (success, syncedObjects, error) in
            completion(success, syncedObjects, nil)
            
            // post note
            var userInfo: [String: Any] = [:]
            if let sd = syncedObjects {
                userInfo = ["kSynced": sd]
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: ACSyncAllCompletedNotification), object: nil, userInfo: userInfo)
        }
    }

}

// MARK: - Context Owner -

extension ACSyncCoordinator: ContextOwnerType {
    /// The Sync Coordinator holds onto tokens used to register with the NSNotificationCenter.
    func addObserverToken(_ token: NSObjectProtocol) {
        precondition(didSetup, "Did not call setup()")
        observerTokens.append(token)
    }
    func removeAllObserverTokens() {
        precondition(didSetup, "Did not call setup()")
        observerTokens.removeAll()
    }
    
    func processChangedLocalObjects(_ objects: [NSManagedObject]) {
        precondition(didSetup, "Did not call setup()")
        /*
        for cp in changeProcessors {
            cp.processChangedLocalObjects(objects, context: self)
        }
        */
    }
}

extension ACSyncCoordinator {
    func registerValueTransformers() {
        // should only run once
        ValueTransformer.setValueTransformer(STJsonImagesTransformer(), forName: NSValueTransformerName(rawValue: "kSTJsonImagesTransformer"))
        ValueTransformer.setValueTransformer(STJsonGenresTransformer(), forName: NSValueTransformerName(rawValue: "kSTJsonGenresTransformer"))
        ValueTransformer.setValueTransformer(STJsonContentPackagesTransformer(), forName: NSValueTransformerName(rawValue: "kSTJsonContentPackagesTransformer"))
    }
}
