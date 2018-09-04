//
//  ACBorderedLabel.swift
//  <?>App
//
//  Created by Austin Chen on 2016-08-12.
//  Copyright © 2016 10.1. All rights reserved.
//

import UIKit

@IBDesignable
class ACBorderedLabel: UILabel {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    // @IBInspectable UIEdgeInsets is not supported yet, so workaround like below
    @IBInspectable var textInsets: CGRect = CGRect()
    
    // to add a content insets
    override func draw(_ rect: CGRect) {
        let insets = UIEdgeInsets(top: textInsets.origin.x,
                                  left: textInsets.origin.y,
                                  bottom: textInsets.size.width,
                                  right: textInsets.size.height)
        self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
