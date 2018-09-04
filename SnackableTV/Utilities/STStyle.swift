//
//  STStyle.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-12.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

let kAppNameForAlertTitle = "SnackableTV"

class STStyle {
    static func configureAppStyle() {
        // needs .plist UIViewControllerBasedStatusBarAppearance to be NO
        UIApplication.shared.isStatusBarHidden = true
        UIApplication.shared.swizzleStatusBar() // only objc works for AVEEngine trying to hide status bar
    }
}

// Sample color palette

extension UIColor {
    class var stYellow: UIColor {
        return UIColor(red: 254.0 / 255.0, green: 207.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    }
    
    class var stLightOrange: UIColor {
        return UIColor(red: 253.0 / 255.0, green: 189.0 / 255.0, blue: 57.0 / 255.0, alpha: 1.0)
    }
    
    class var stPeach: UIColor {
        return UIColor(red: 238.0 / 255.0, green: 103.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0)
    }
}

// Sample text styles

extension UIFont {
    class func stHeaderFont() -> UIFont {
        return UIFont.montserratFont(ofSize: 24.0, weight: UIFontWeightRegular)
    }
}


extension UIApplication {
    var newIsStatusBarHidden: Bool {
        get {
            return true
        }
        set {
            print("newIsStatusBarHidden")
        }
    }
    
    func newSetStatusBarHidden(_ hidden: Bool, with animation: UIStatusBarAnimation) {
        print("newSetStatusBarHidden")
    }
}
