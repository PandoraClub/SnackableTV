//
//  STJsonImage.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-05.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class STJsonImage: NSObject, Mappable {
    var type: String?
    var url: String?
    var width: Int16?
    var height: Int16?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        type <- map["Type"]
        url <- map["Url"]
        width <- map["Width"]
        height <- map["Height"]
    }
}

extension STJsonImage {
    func url(withSize size: CGSize) -> String? {
        let w = Int(size.width)
        let h = Int(size.height)
        
        let params = "?width=\(w)&height=\(h)&maintain_aspect=1"
        if let u = url {
            return u + params
        } else {
            return nil
        }
    }
}
