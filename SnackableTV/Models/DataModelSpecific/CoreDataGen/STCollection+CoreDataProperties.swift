//
//  STCollection+CoreDataProperties.swift
//  
//
//  Created by Austin Chen on 2017-04-06.
//
//

import Foundation
import CoreData


extension STCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<STCollection> {
        return NSFetchRequest<STCollection>(entityName: "STCollection")
    }

    @NSManaged var name: String?
    @NSManaged var desc: String?
    @NSManaged var isAutoGen: Bool
    @NSManaged var itemsType: String?
    @NSManaged var parentCollection: STCollection?
    @NSManaged var childCollections: NSOrderedSet?
    @NSManaged var medias: NSOrderedSet?
    @NSManaged var contents: NSOrderedSet?

}

extension STCollection {
    var url: String {
        return ACSettings.shared.host.prefixUrl + "/collections/\(self.id)"
    }
}
