//
//  ACBase+CoreDataProperties.swift
//  
//
//  Created by Austin Chen on 2017-04-05.
//
//

import Foundation
import CoreData

extension ACBase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ACBase> {
        return NSFetchRequest<ACBase>(entityName: "ACBase")
    }

    @NSManaged public var id: Int64
    @NSManaged public var order: Int
}
