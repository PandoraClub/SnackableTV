//
//  NSAttributedStringPlus.swift
//  <?>App
//
//  Created by Austin Chen on 2016-10-11.
//  Copyright © 2016 10.1. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    class func wholeWithPart(whole: String,
                            wholeAttributes: [String:AnyObject],
                            attributedPart: String,
                            partAttributes: [String:AnyObject]) -> NSAttributedString
    {
        let index = whole.index(ofSubstr: attributedPart) ?? 0
        
        let myMutableString = NSMutableAttributedString(string: whole, attributes: wholeAttributes)
        myMutableString.addAttributes(partAttributes, range: NSMakeRange(index, attributedPart.characters.count))
        return myMutableString
    }
    
    // MARK: convenience
    class func attributesForSemiboldWhiteFont(_ fontSize: CGFloat) -> [String:AnyObject] {
        return NSAttributedString.attributesForFont(fontSize, weight: UIFontWeightSemibold, color: UIColor.white)
    }
    
    class func attributesForSemiboldFont(_ fontSize: CGFloat, color: UIColor) -> [String:AnyObject] {
        return NSAttributedString.attributesForFont(fontSize, weight: UIFontWeightSemibold, color: color)
    }
    
    class func attributesForRegularWhiteFont(_ fontSize: CGFloat) -> [String:AnyObject] {
        return NSAttributedString.attributesForFont(fontSize, weight: UIFontWeightRegular, color: UIColor.white)
    }
    
    class func attributesForRegularFont(_ fontSize: CGFloat, color: UIColor) -> [String:AnyObject] {
        return NSAttributedString.attributesForFont(fontSize, weight: UIFontWeightRegular, color: color)
    }
    
    // MARK:
    class func attributesForFont(_ fontSize: CGFloat, weight: CGFloat, color: UIColor) -> [String:AnyObject] {
        return [NSFontAttributeName : UIFont.systemFont(ofSize: fontSize, weight: weight),
                NSForegroundColorAttributeName: color]
    }
}

extension NSMutableAttributedString {
    
    func attribute(part:String, index:Int, partAttributes:[String:AnyObject]) {
        if (index + part.length < self.length) {
            self.addAttributes(partAttributes, range: NSMakeRange(index, part.characters.count))
        } else {
            print("NSAttributedStringPlus error adding attribute: out of bound")
        }
    }
    
    
    
    // KK
    func blue(_ text:String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 20)!, NSForegroundColorAttributeName : #colorLiteral(red: 0, green: 0.5960784314, blue: 0.9294117647, alpha: 1)]
        let blueString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(blueString)
        return self
    }
  
    
    func black(_ text:String)->NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 20)!, NSForegroundColorAttributeName : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        let blackString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(blackString)
        return self
    }
    
}
