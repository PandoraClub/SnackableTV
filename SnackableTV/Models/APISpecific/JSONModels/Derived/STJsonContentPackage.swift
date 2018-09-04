//
//  STJsonContentPackage.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-05.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class STJsonContentPackage: ACSyncableJsonRecord {
    var name: String?
    var desc: String?
    var duration: Float?
    var images: [STJsonImage]?
    var scheduleStartDateTime: Date?
    var scheduleEndDateTime: Date?
    
    var securityType: String?
    
    // relationship info
    var contentId: Int64?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["Name"]
        desc <- map["Desc"]
        duration <- map["Duration"]
        images <- map["Images"]
        contentId <- map["Content.Id"]
        
        scheduleStartDateTime <- (map["ScheduleStartDateTime"], ISO8601DateTransform())
        scheduleEndDateTime <- (map["ScheduleEndDateTime"], ISO8601DateTransform())
        
        securityType <- (map["Constraints.Security.Type"])
    }
}
