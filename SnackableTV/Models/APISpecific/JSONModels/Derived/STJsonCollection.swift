//
//  STJsonCollection.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-25.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class STJsonCollection: ACSyncableJsonRecord {
    var name: String?
    var desc: String?
    var isAutoGen: Bool?
    var itemsType: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["Name"]
        desc <- map["Desc"]
        isAutoGen <- map["IsAutoGen"]
        itemsType <- map["ItemsType"]
    }
}
