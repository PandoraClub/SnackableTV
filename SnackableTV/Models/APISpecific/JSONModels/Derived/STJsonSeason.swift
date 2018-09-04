//
//  STJsonSeason.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-26.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class STJsonSeason: ACSyncableJsonRecord {
    
    var name: String?
    var number: Int?
    var images: [STJsonImage]?
    
    var mediaId: Int64?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["Name"]
        number <- map["Number"]
        images <- map["Images"]
        
        mediaId <- map["Media.Id"]
    }
}
