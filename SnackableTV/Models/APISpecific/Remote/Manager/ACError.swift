//
//  ACError.swift
//  <?>App
//
//  Created by Austin Chen on 2016-12-19.
//  Copyright © 2016 10.1. All rights reserved.
//

import Foundation
import Alamofire

enum ACError: Error {
    case remoteError(error: AFError)
    case coreDataError
    case keyChainError
}

extension ACError {
    public var errorDescription: String? {
        switch self {
        case .remoteError(let error):
            return "ACError - HTTP: \(error)"
        case .coreDataError:
            return "ACError - CoreData: "
        case .keyChainError:
            return "ACError - KeyChain: "
        }
    }
}
