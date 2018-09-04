//
//  STMedia+CoreDataProperties.swift
//  
//
//  Created by Austin Chen on 2017-04-25.
//
//

import Foundation
import CoreData

extension STMedia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<STMedia> {
        return NSFetchRequest<STMedia>(entityName: "STMedia")
    }

    @NSManaged var agvotCode: String?
    @NSManaged var containsSeasons: Bool
    @NSManaged var desc: String?
    @NSManaged var dfpName: String?
    @NSManaged var genres: [STJsonGenre]?
    @NSManaged var images: [STJsonImage]?
    @NSManaged var name: String?
    @NSManaged var qfrCode: String?
    @NSManaged var shortDesc: String?
    @NSManaged var type: String?
    @NSManaged var collections: NSOrderedSet?
    @NSManaged var contents: NSOrderedSet?

}

extension STMedia {
    var url: String {
        return ACSettings.shared.host.prefixUrl + "/medias/\(self.id)"
    }
}
