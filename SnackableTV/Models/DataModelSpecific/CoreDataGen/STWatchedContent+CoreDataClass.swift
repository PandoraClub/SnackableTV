//
//  STWatchedContent+CoreDataClass.swift
//  
//
//  Created by Austin Chen on 2017-05-01.
//
//

import Foundation
import CoreData

@objc(STWatchedContent)
public class STWatchedContent: NSManagedObject {

    func saveProperties(progressPercentage: Float,
                        startedTime: Date?,
                        updatedTime: Date?,
                        content: STContent?)
    {
        self.progressPercentage = progressPercentage as NSNumber?
        self.startedTime = startedTime as NSDate?
        self.updatedTime = updatedTime as NSDate?
        
        if let c = content {
            self.setValue(c, forKey: "content")
        }
    }
}
