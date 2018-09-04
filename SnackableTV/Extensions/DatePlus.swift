//
//  DatePlus.swift
//  <?>App
//
//  Created by Austin Chen on 2016-11-16.
//  Copyright © 2016 10.1. All rights reserved.
//

import Foundation

extension Date {
    
    static func date(fromString str: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let date = df.date(from: str)
        return date
    }
    
    var toTimestamp: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        return f.string(from: self)
    }
}
