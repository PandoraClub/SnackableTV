//
//  STStoryboardFactory.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-03.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class STStoryboardFactory: NSObject {
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static var loginStoryboard: UIStoryboard {
        return UIStoryboard(name: "Login", bundle: nil)
    }
    
    static var miscStoryboard: UIStoryboard {
        return UIStoryboard(name: "Misc", bundle: nil)
    }
}

// MARK: debug
extension STStoryboardFactory {
    static var debugStoryboard: UIStoryboard {
        return UIStoryboard(name: "Debug", bundle: nil)
    }
}
