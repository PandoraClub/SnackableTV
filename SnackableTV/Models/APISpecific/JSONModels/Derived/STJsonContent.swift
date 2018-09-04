//
//  STJsonContent.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-05.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class STJsonContent: ACSyncableJsonRecord {
    var name: String?
    var desc: String?
    var shortDesc: String?
    var type: String?
    var genres: [STJsonGenre]?
    var images: [STJsonImage]?
    
    var agvotCode: String?
    var qfrCode: String?
    var episode: Int?
    var broadcastDateTime: Date?
    
    // ?$include=*
    var mediaId: Int64?
    var seasonId: Int64?
    var contentPackages: [STJsonContentPackage]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["Name"]
        desc <- map["Desc"]
        shortDesc <- map["ShortDesc"]
        type <- map["Type"]
        genres <- map["Genres"]
        images <- map["Images"]
        
        agvotCode <- map["AgvotCode"]
        qfrCode <- map["QfrCode"]
        episode <- map["Episode"]
        broadcastDateTime <- (map["BroadcastDateTime"], ISO8601DateTransform())
        
        mediaId <- map["Media.Id"]
        seasonId <- map["Season.Id"]
        contentPackages <- map["ContentPackages"]
    }
}
