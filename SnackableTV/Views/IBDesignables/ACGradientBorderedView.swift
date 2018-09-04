//
//  ACGradientBorderedView.swift
//  <?>App
//
//  Created by Austin Chen on 2016-08-15.
//  Copyright © 2016 10.1. All rights reserved.
//

import UIKit

// Vertical gradient only

@IBDesignable
class ACGradientBorderedView: ACBorderedView {

    @IBInspectable var colorA: UIColor?
    @IBInspectable var colorB: UIColor?
    @IBInspectable var vertical: Bool = true
    
    var gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds;
    }
    
    override func draw(_ rect: CGRect) {
        // remove sublayers
        gradientLayer.removeFromSuperlayer()
        
        // set up header view
        
        gradientLayer.frame = self.bounds;
        
        // set horizontal gradient
        if !vertical {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5) // mid left
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5) // mid right
        }
        
        var gradientColors: [AnyObject] = []
        if let cA = self.colorA {
            gradientColors.append(cA.cgColor)
        }
        if let cB = self.colorB {
            gradientColors.append(cB.cgColor)
        }
        gradientLayer.colors = gradientColors
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

}
