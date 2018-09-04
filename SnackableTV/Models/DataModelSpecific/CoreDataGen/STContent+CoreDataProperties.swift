//
//  STContent+CoreDataProperties.swift
//  
//
//  Created by Austin Chen on 2017-04-06.
//
//

import Foundation
import CoreData

extension STContent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<STContent> {
        return NSFetchRequest<STContent>(entityName: "STContent")
    }

    @NSManaged var agvotCode: String?
    @NSManaged var qfrCode: String?
    @NSManaged var episode: Int
    @NSManaged var broadcastDateTime: Date?
    
    @NSManaged var name: String?
    @NSManaged var desc: String?
    @NSManaged var shortDesc: String?
    @NSManaged var type: String?
    @NSManaged var genres: [STJsonGenre]?
    @NSManaged var images: [STJsonImage]?
    
    @NSManaged var media: STMedia?
    @NSManaged var contentPackages: [STJsonContentPackage]?
    @NSManaged var packages: NSOrderedSet?
    @NSManaged var collections: NSOrderedSet?
    @NSManaged var watchedContent: STWatchedContent?
}

extension STContent {
    var isLiveStream: Bool {
        guard let t = type else { return false }
        
        return t ~= "stream" ? true : false
    }
    
    var isUncensored: Bool {
        guard let c = agvotCode else { return false }
        
        return c ~= "18+" ? true : false
    }
    
    var streamUrlString: String? {
        guard let packageId = self.contentPackages?.first?.id
            else { return nil }
        
        return ACSettings.shared.host.prefixUrl + "/contents/\(id)/contentpackages/\(packageId)/manifest.m3u8"
    }
    
    var firstContentPackage: STContentPackage? {
        return (self.packages?.array.first as? STContentPackage)
    }
    
    var firstContentPackagePath: String? {
        guard let cp = self.contentPackages?.first
            else { return nil }
        
        let cpPath: String = ACSettings.shared.host.prefixUrl + "/contents/\(self.id)/contentPackages/\(cp.id)"
        return cpPath
    }
}
