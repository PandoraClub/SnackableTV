//
//  STJsonMedia.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-25.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class STJsonMedia: ACSyncableJsonRecord {
    
    var name: String?
    var type: String?
    var desc: String?
    var shortDesc: String?
    
    var agvotCode: String?
    var containsSeasons: Bool?
    var dfpName: String?
    var qfrCode: String?
    
    var genres: [STJsonGenre]?
    var images: [STJsonImage]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["Name"]
        type <- map["Type"]
        desc <- map["Desc"]
        shortDesc <- map["ShortDesc"]
        
        agvotCode <- map["AgvotCode"]
        containsSeasons <- map["ContainsSeasons"]
        dfpName <- map["DFPName"]
        qfrCode <- map["QfrCode"]
        
        genres <- map["Genres"]
        images <- map["Images"]
    }
}
