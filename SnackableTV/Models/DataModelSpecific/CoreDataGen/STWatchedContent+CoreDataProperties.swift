//
//  STWatchedContent+CoreDataProperties.swift
//  
//
//  Created by Austin Chen on 2017-05-01.
//
//

import Foundation
import CoreData

extension STWatchedContent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<STWatchedContent> {
        return NSFetchRequest<STWatchedContent>(entityName: "STWatchedContent")
    }

    @NSManaged public var progressPercentage: NSNumber?
    @NSManaged public var startedTime: NSDate?
    @NSManaged public var updatedTime: NSDate?
    @NSManaged public var content: STContent?
}
