//
//  IntPlus.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-13.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

extension Int {
    func secondsToTimeString() -> String {
        let seconds = self % 60
        let minutes = (self / 60) % 60
        let hours = self / (60 * 60)
        var string = ""
        if hours > 0 {
            string = String(format: "%d:%02d:%02d", hours, minutes, seconds) //"\(hours):\(minutes):\(seconds)"
        } else {
            string = String(format: "%02d:%02d", minutes, seconds) // "\(minutes):\(seconds)"
        }
        return string
    }
}

extension Integer { // Int, Int64, etc
    var toString: String {
        return String(describing: self)
    }
}
