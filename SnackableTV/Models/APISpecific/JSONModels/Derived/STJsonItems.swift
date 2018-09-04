//
//  STJsonItems.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-05.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

typealias STJsonBasicItems = STJsonItems<STJsonItem>

class STJsonItems<T: Mappable>: Mappable {
    var items: [T]?
    var itemsType: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        items <- map["Items"]
        itemsType <- map["ItemsType"]
    }
}

class STJsonItem: ACSyncableJsonRecord {
    var name: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["Name"]
    }
}
