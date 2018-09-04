//
//  AlamoResponse+Validation.swift
//  <?>App
//
//  Created by Austin Chen on 2016-09-15.
//  Copyright © 2016 10.1. All rights reserved.
//

import Alamofire
import ObjectMapper
import AlamofireObjectMapper

/* Validate remote response and HTTP status code via Alamofire
 */
protocol ACResponseValidation {
    var isValid: Bool {get}
}

extension Alamofire.DataResponse: ACResponseValidation {
    var isValid: Bool {
        get {
            if let r = self.response , r.statusCode >= 200 && r.statusCode < 300 {
                return true
            } else {
                return false
            }
        }
    }
}
