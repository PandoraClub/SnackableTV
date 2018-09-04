//
//  STSeason+CoreDataProperties.swift
//  
//
//  Created by Austin Chen on 2017-04-26.
//
//

import Foundation
import CoreData

extension STSeason {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<STSeason> {
        return NSFetchRequest<STSeason>(entityName: "STSeason")
    }

    @NSManaged var name: String?
    @NSManaged var number: NSNumber?
    @NSManaged var images: [STJsonImage]?
    @NSManaged var media: STMedia?
}
