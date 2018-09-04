//
//  STJsonContentPackagesTransformer.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-25.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

class STJsonContentPackagesTransformer: ValueTransformer {
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        return (value as? [STJsonContentPackage])?.toJSONString()?.data(using: String.Encoding.utf8)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        if let v = value as? NSData,
            let jsonString = String(data: v as Data, encoding: String.Encoding.utf8)
        {
            return Array<STJsonContentPackage>.init(JSONString: jsonString)
        }
        return nil
    }
}
