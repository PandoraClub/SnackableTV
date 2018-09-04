//
//  ACHost.swift
//  <?>App
//
//  Created by Austin Chen on 2017-01-26.
//  Copyright © 2017 10.1. All rights reserved.
//

import Foundation

struct ACHost {
    let name: String
    let domain: String
}

extension ACHost {
    static let hosts: [ACHost] = [ACHost(name: "Prod", domain: "capi.9c9media.com"),
                                   ACHost(name: "Staging", domain: "capi.stage.9c9media.com")]
    
    var prefixUrl: String {
        return "http://" + domain + "/destinations/snack_ios/platforms/iphone"
    }
}
