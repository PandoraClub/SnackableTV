//
//  UINavigationControllerExtension.swift
//  <?>App
//
//  Created by Austin Chen on 2016-08-26.
//  Copyright © 2016 10.1. All rights reserved.
//

import Foundation

extension UINavigationController {
    var rootViewController: UIViewController? {
        if self.viewControllers.count > 0 {
            return self.viewControllers[0]
        } else {
            return nil
        }
    }
}
