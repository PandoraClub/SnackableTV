//
//  CGFloatPlus.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-12.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

enum STAspectRatio {
    case sixteenByNine
    case threeByTwo
}

extension CGFloat {
    func stSmallerValue(byAspectRatio ratio: STAspectRatio) -> CGFloat {
        switch ratio {
        case .sixteenByNine:
            return (9.0 / 16.0) * self
        case .threeByTwo:
            return (2.0 / 3.0) * self
        }
    }
    
    func stLargerValue(byAspectRatio ratio: STAspectRatio) -> CGFloat {
        switch ratio {
        case .sixteenByNine:
            return (16.0 / 9.0) * self
        case .threeByTwo:
            return (3.0 / 2.0) * self
        }
    }
}
