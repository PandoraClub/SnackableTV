//
//  ACBlurOutAnimator.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-27.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class ACBlurOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? STMenuViewController else { return }
        
        transitionContext.containerView.addSubview(fromVC.view)
        
        UIView.animate(withDuration: kDuration, animations: {
            fromVC.visualEffectView.effect = nil
            fromVC.visualEffectView.contentView.alpha = 0
            fromVC.noEffectContainerView.alpha = 0
        }, completion: { finished in
            fromVC.visualEffectView.contentView.alpha = 1.0
            fromVC.noEffectContainerView.alpha = 1.0
            transitionContext.completeTransition(finished)
        })
    }
}

fileprivate let kDuration = 0.4
