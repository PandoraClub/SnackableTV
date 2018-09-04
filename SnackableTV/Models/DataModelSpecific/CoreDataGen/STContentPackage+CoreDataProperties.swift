//
//  STContentPackage+CoreDataProperties.swift
//  
//
//  Created by Austin Chen on 2017-04-06.
//
//

import Foundation
import CoreData

extension STContentPackage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<STContentPackage> {
        return NSFetchRequest<STContentPackage>(entityName: "STContentPackage")
    }

    @NSManaged var name: String?
    @NSManaged var desc: String?
    @NSManaged var duration: NSNumber?
    @NSManaged var images: [STJsonImage]?
    @NSManaged var scheduleStart: Date?
    @NSManaged var scheduleEnd: Date?
    @NSManaged var securityType: String?
    
    @NSManaged var contentId: Int64
    @NSManaged var content: STContent?
}
