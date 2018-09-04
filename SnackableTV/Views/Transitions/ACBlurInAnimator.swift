//
//  ACBlurInAnimator.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-27.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class ACBlurInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? STMenuViewController else { return }
        
        transitionContext.containerView.addSubview(toVC.view)
        toVC.visualEffectView.effect = nil
        toVC.visualEffectView.contentView.alpha = 0
        toVC.noEffectContainerView.alpha = 0
        
        UIView.animate(withDuration: kDuration, animations: {
            toVC.visualEffectView.effect = UIBlurEffect(style: .light)
            toVC.visualEffectView.contentView.alpha = 1.0
            toVC.noEffectContainerView.alpha = 1.0
        }, completion: { finished in
            toVC.visualEffectView.contentView.alpha = 1.0
            toVC.noEffectContainerView.alpha = 1.0
            transitionContext.completeTransition(finished)
        })
    }
}

fileprivate let kDuration = 0.4
