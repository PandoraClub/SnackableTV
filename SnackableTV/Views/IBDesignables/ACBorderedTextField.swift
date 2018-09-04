//
//  ACBorderedTextField.swift
//  <?>App
//
//  Created by Austin Chen on 2016-08-12.
//  Copyright © 2016 10.1. All rights reserved.
//

import UIKit

@IBDesignable
class ACBorderedTextField: UITextField {
    
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
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: textInsets.origin.y, dy: textInsets.size.height);
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: textInsets.origin.y, dy: textInsets.size.height);
    }
    
    @IBInspectable var placeholderFontColor: UIColor?
    @IBInspectable var placeholderFontSize: CGFloat = 0
    private var isAttributedPlaceholderSet = false // prevent repeated setting placehoder, as it causes crash for ios 9
    
    // MARK: life cycle 
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isAttributedPlaceholderSet,
            let ph = self.placeholder,
            let phc = placeholderFontColor
        {
            self.attributedPlaceholder = NSAttributedString(string: ph, attributes:
                [NSFontAttributeName : UIFont.systemFont(ofSize: placeholderFontSize, weight: UIFontWeightRegular),
                 NSForegroundColorAttributeName: phc])
            isAttributedPlaceholderSet = true
        }
        
    }
}
