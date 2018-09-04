//
//  ACRoundBorderButton.swift
//  <?>App
//
//  Created by Austin Chen on 2016-08-25.
//  Copyright © 2016 10.1. All rights reserved.
//

import UIKit

class ACRoundBorderButton: ACBorderedButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.size.height / 2.0
    }

}
