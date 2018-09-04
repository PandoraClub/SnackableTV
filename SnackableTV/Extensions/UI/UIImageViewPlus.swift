//
//  UIImageViewPlus.swift
//  <?>App
//
//  Created by Austin Chen on 2016-11-15.
//  Copyright © 2016 10.1. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    
    func sdSetImage(withString string: String?) {
        let phImageName = "imgPlaceholder"
        self.sdSetImage(withString: string, placeholderName: phImageName)
    }
    
    func sdSetImage(withString string: String?, placeholderName pl: String) {
        guard let str = string
            else { return }
        
        let phImage = UIImage(named: pl)
        self.sd_setImage(with: URL(string: str), placeholderImage: phImage)
    }
    
    func sdSetImage(withString string: String?,
                    scaleToFillWhenFinished: Bool? = false,
                    options: SDWebImageOptions = [])
    {
        self.sdSetImage(withString: string, scaleToFillWhenFinished: scaleToFillWhenFinished, options: options, completed: nil)
    }
    
    func sdSetImage(withString string: String?,
                         scaleToFillWhenFinished: Bool? = false,
                         options: SDWebImageOptions = [],
                         completed completedBlock: SDWebImage.SDExternalCompletionBlock? = nil)
    {
        guard let str = string
            else { return }
        
        let phImageName = "imgPlaceholder"
        let phImage = UIImage(named: phImageName)
        
        self.sd_setImage(with: URL(string: str), placeholderImage: phImage, options: options)
        { (image, error, cacheType, url) in
            if scaleToFillWhenFinished ?? false {
                self.contentMode = .scaleToFill
            }
            
            if let c = completedBlock {
                c(image, error, cacheType, url)
            }
        }
    }
}
