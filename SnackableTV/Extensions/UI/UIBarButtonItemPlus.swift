//
//  UIBarButtonItemPlus.swift
//  <?>App
//
//  Created by Austin Chen on 2016-11-16.
//  Copyright © 2016 10.1. All rights reserved.
//

import Foundation

extension UIBarButtonItem {
    static func barButtonItem(withImageName name: String, forTarget target: Any?, action: Selector) -> UIBarButtonItem {
        // set up image
        let img = UIImage(named: name)?.withRenderingMode(.alwaysOriginal) // the image has to be masked properly
        
        // set up button
        let leftButton = UIButton()
        leftButton.setImage(img, for: .normal)
        leftButton.bounds = CGRect(x: 0, y: 0, width: img!.size.width, height: img!.size.height)
        leftButton.addTarget(target, action: action, for: .touchUpInside)
        leftButton.tintColor = UIColor.black
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -17, 0, 0)
        
        // set up bar button
        return UIBarButtonItem(customView: leftButton)
    }
}
