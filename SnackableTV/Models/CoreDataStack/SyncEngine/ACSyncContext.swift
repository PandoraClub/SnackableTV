//
//  ACSyncContext.swift
//  <?>App
//
//  Created by Austin Chen on 2016-05-26.
//

import Foundation
import CoreData

// sync context
enum ACSyncPendingTaskDomain: String {
    case None, ProfileProcessing, SurveyProcessing, SurveyResponseUploading, ScheduleProcessing
}
enum ACSyncPendingTaskPriority: Int {
    case low = 0, medium, high
}

class ACSyncPendingTask: NSObject {
    var taskDomain: ACSyncPendingTaskDomain = .None
    var taskPriority: ACSyncPendingTaskPriority = .low
    var taskAction: String = ""
}

class ACSyncContext: NSObject {
    // remote context
    var remoteSession: ACRemoteSession?
    
    // local CoreData context
    var managedObjectContext: NSManagedObjectContext?
    
    // a list of to-do items
    var pendingTasks: [ACSyncPendingTask] = []
}

// serializing ACSyncContext
extension ACSyncContext {
    convenience init (remoteSession: ACRemoteSession?, managedObjectContext: NSManagedObjectContext?) {
        self.init()
        self.remoteSession = remoteSession
        self.managedObjectContext = managedObjectContext
    }
    
    convenience init?(coder decoder: NSCoder) {
        self.init()
        if let pt = decoder.decodeObject(forKey: "pendingTasks") as? [ACSyncPendingTask] {
            self.pendingTasks = pt
        }
    }
    
    func encodeWithCoder(_ coder: NSCoder) {
        coder.encode(self.pendingTasks, forKey: "pendingTasks")
    }
}
