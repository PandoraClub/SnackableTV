//
//  String+Localizable.swift
//  <?>App
//
//  Created by Austin Chen on 2016-11-07.
//  Copyright © 2016 10.1. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
