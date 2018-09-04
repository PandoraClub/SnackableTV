//
//  ACBorderedImageView.swift
//  <?>App
//
//  Created by Austin Chen on 2016-09-01.
//  Copyright © 2016 10.1. All rights reserved.
//

import UIKit

@IBDesignable
class ACBorderedImageView: UIImageView {

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
    
    @IBInspectable var edgeInsets: CGRect = CGRect() {
        didSet {
            let insets = UIEdgeInsets(top: edgeInsets.origin.x,
                                      left: edgeInsets.origin.y,
                                      bottom: edgeInsets.size.width,
                                      right: edgeInsets.size.height)
            self.layoutMargins = insets
        }
    }

}
