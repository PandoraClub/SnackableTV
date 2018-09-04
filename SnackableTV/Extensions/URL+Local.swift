//
//  URL+Local.swift
//  <?>App
//
//  Created by Austin Chen on 2017-01-26.
//  Copyright © 2017 10.1. All rights reserved.
//

import Foundation

extension URL {
    static func temporaryURL() -> URL {
        let url = try! FileManager.default.url(for: FileManager.SearchPathDirectory.cachesDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: true)
        return url.appendingPathComponent(UUID().uuidString)
    }
    static var documentsURL: URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}
