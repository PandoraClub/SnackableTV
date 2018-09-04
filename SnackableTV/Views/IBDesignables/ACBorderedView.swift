//
//  ACBorderedView.swift
//  <?>App
//
//  Created by Austin Chen on 2016-08-16.
//  Copyright © 2016 10.1. All rights reserved.
//

import UIKit

@IBDesignable
class ACBorderedView: UIView {
    
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
    
    // MARK: hideable properties
    internal var heightConstraint: NSLayoutConstraint?
    internal var defaultHeight: CGFloat = 0
    
    // MARK: shadow
    
    @IBInspectable var shadowColor: UIColor? = nil
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0)
    @IBInspectable var shadowOpacity: CGFloat = 1.0
    @IBInspectable var shadowRadius: CGFloat = 0.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let sc = self.shadowColor {
            // layer.masksToBounds = false
            layer.shadowColor = sc.cgColor
            layer.shadowOffset = self.shadowOffset
            layer.shadowOpacity = Float(self.shadowOpacity)
            layer.shadowRadius = self.shadowRadius
        }
    }
}

protocol ACHideableViewProtocol {
    var heightConstraint: NSLayoutConstraint? {get set}
    var defaultHeight: CGFloat {get set}
    func setIsHidden(_ hidden: Bool, animated: Bool, completion: ((Bool) -> ())?)
}

extension ACBorderedView: ACHideableViewProtocol{
    // MARK: instance methods
    
    override var isHidden: Bool {
        didSet {
            guard oldValue != isHidden else {
                return
            }
            
            if isHidden {
                self.heightConstraint?.constant = 0.0
            } else {
                self.heightConstraint?.constant = self.defaultHeight
            }
            self.superview?.layoutIfNeeded()
        }
    }
    
    // MARK: instance methods
    
    func setIsHidden(_ hidden: Bool, animated: Bool, completion: ((Bool) -> ())? = nil) {
        guard hidden != self.isHidden else {
            return
        }
        
        guard animated else {
            self.isHidden = hidden
            if let c = completion { c(true) }
            return
        }
        
        if hidden {
            self.heightConstraint?.constant = 0.0
        } else {
            self.heightConstraint?.constant = self.defaultHeight
            super.isHidden = false
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.superview?.layoutIfNeeded()
        }, completion: { (finished) in
            super.isHidden = hidden
            if let c = completion { c(finished) }
        })
    }
}
