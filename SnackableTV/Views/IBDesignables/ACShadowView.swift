//
//  ACShadowView.swift
//  <?>App
//
//  Created by Austin Chen on 2016-09-29.
//  Copyright © 2016 10.1. All rights reserved.
//

import UIKit

/**
    this view contains a child view which can create a border around itself.
    the reason for creating a child view is the fact that masksToBounds needs to be one value for creating a border, while being the opposite value for having a shadow.
 
    Note: self.backgroundColor is hardcoded to be clear, even though it is stated differently on storyboard
    Ref: http://stackoverflow.com/a/34984063
 */
@IBDesignable
class ACShadowView: UIView {

    @IBInspectable var foregroundColor: UIColor? = nil
    
    @IBInspectable var borderColor: UIColor? = nil
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var cornerRadius: CGFloat = 0
    
    @IBInspectable var shadowColor: UIColor? = nil
    @IBInspectable var shadowOffset: CGSize = CGSize.zero
    @IBInspectable var shadowBlurRadius: CGFloat = 0
    @IBInspectable var shadowOpacity: CGFloat = 0
    
    private var borderView = UIView()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // add the shadow to the base view
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = shadowColor?.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = Float(shadowOpacity)
        self.layer.shadowRadius = shadowBlurRadius
        self.layer.masksToBounds = false
        
        if borderView.superview == nil {
            borderView.frame = self.bounds
            borderView.backgroundColor = foregroundColor
            borderView.layer.cornerRadius = cornerRadius
            borderView.layer.borderColor = borderColor?.cgColor
            borderView.layer.borderWidth = borderWidth
            borderView.layer.masksToBounds = true
            self.addSubview(borderView)
        }
        
        // Adding rounded corners and shadows can be a performance hit. You can improve performance by using a predefined path for the shadow and also specifying that it be rasterized. The following code can be added to the example above.
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
