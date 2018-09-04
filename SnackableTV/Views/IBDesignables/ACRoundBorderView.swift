//
//  ACRoundBorderView.swift
//  <?>App
//
//  Created by Thomas Varghese on 2017-05-04.
//  Copyright © 2016 10.1. All rights reserved.
//

import UIKit

class ACRoundBorderView: ACBorderedView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.size.height / 2.0
    }
    
}
