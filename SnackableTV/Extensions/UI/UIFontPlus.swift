//
//  UIFontPlus.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-17.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

extension UIFont {
    open class func montserratFont(ofSize fontSize: CGFloat, weight: CGFloat? = nil) -> UIFont {
        var weightStr = "Regular"
        
        if let w = weight {
            switch w {
            case UIFontWeightUltraLight:
                weightStr = "UltraLight"
            case UIFontWeightThin:
                weightStr = "Thin"
            case UIFontWeightLight:
                weightStr = "Light"
            case UIFontWeightRegular:
                weightStr = "Regular"
            case UIFontWeightMedium:
                weightStr = "Medium"
            case UIFontWeightSemibold:
                weightStr = "Semibold"
            case UIFontWeightBold:
                weightStr = "Bold"
            case UIFontWeightBlack:
                weightStr = "Black"
            default:
                break
            }
        }
        
        return UIFont(name: "Montserrat-" + weightStr, size: fontSize)!
    }
}
