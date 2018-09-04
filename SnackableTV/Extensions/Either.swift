//
//  Either.swift
//  <?>App
//
//  Created by Austin Chen on 2016-11-22.
//  Copyright © 2016 10.1. All rights reserved.
//

import Foundation

enum Either<T1, T2> {
    case left(T1)
    case right(T2)
}

extension Either {
    var leftValue: T1? {
        if case .left(let v) = self {
            return v
        }
        return nil
    }
    
    var rightValue: T2? {
        if case .right(let v) = self {
            return v
        }
        return nil
    }
}
