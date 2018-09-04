//
//  STWatchHistoryProcessor.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-05-01.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import CoreData

protocol STWatchHistoryProcessorType: ACSyncableProcessorType {
    func updateOrInsertWatchedContent(progressPercentage: Float,
                                      startedTime: Date?,
                                      updatedTime: Date?,
                                      content: STContent,
                                      _ completion: @escaping (_ success: Bool, _ syncedObject: Any?) -> ())
}

@objc class STWatchHistoryProcessor: NSObject, STWatchHistoryProcessorType {
    let syncContext: ACSyncContext
    
    required init (context: ACSyncContext) {
        self.syncContext = context
    }
    
    func sync(_ completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: Error?) -> ()) {
        // dont need to sync with remote for now
    }
    
    func updateOrInsertWatchedContent(progressPercentage: Float,
                                      startedTime: Date?,
                                      updatedTime: Date?,
                                      content: STContent,
                                      _ completion: @escaping (_ success: Bool, _ syncedObject: Any?) -> ())
    {
        var watchedContent = content.watchedContent
        
        guard let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator else
        {
            completion(false, watchedContent)
            return
        }
        
        DispatchQueue.main.async {
            let mainMoc = syncCoordinator.coreDataStack.mainManagedObjectContext
            
            // update
            if watchedContent == nil {
                watchedContent = STWatchedContent.insertObject(byContext: mainMoc) as STWatchedContent
                content.watchedContent = watchedContent
            }
            watchedContent!.saveProperties(progressPercentage: progressPercentage, startedTime: startedTime, updatedTime: updatedTime, content: content)
            
            // save
            if mainMoc.hasChanges {
                try! mainMoc.save()
            }
            completion(true, watchedContent)
        }
    }
}
