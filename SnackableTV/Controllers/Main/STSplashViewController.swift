//
//  STSplashViewController.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-05-09.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

protocol STSplashViewControllerDelegate: class {
    func didStart(splash viewController: UIViewController)
    func shouldComplete(splash viewController: UIViewController)
    func didFinish(splash viewController: UIViewController)
}

class STSplashViewController: UIViewController {
    
    @IBOutlet weak var canvasView: STMosaicsView!
    @IBOutlet weak var overlayView: UIView!

    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var stage1View: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var logoImageViewConstraintWidth: NSLayoutConstraint!
    @IBOutlet weak var descViewConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var buttonConstraintBottom: NSLayoutConstraint!
    @IBAction func buttonTapped(_ sender: Any) {
        self.stage3Animation()
    }
    
    weak var delegate: STSplashViewControllerDelegate?
    private var isStage2Finished = false
    private var isStage3Started = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.delegate?.didStart(splash: self)
        
        self.stage1Animation {
            self.stage2Animation {
                self.stage3Animation()
            }
        }
    }
    
    func stage1Animation(completion: @escaping () -> ()) {
        // animate slide up text
        descViewConstraintBottom.constant = 112
        descView.alpha = 0
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.4, options: .curveEaseOut,
                       animations:
            {
                self.descView.alpha = 1.0
                self.stage1View.layoutIfNeeded()
        }, completion: { finished in
        })
        
        // animate slide up button
        buttonConstraintBottom.constant = 30
        UIView.animate(withDuration: 0.7, delay: 0.5, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.4, options: .curveEaseOut,
                       animations:
            {
                self.stage1View.layoutIfNeeded()
        }, completion: { finished in
            completion()
        })
    }
    
    func stage2Animation(completion: @escaping () -> ()) {
        // animate bg parallax
        let views = self.canvasView.layerViews
        UIView.animate(withDuration: 8.0, delay: 0, options: .curveLinear, animations: {
            var f = views[0].frame
            f.origin.y -= 350.0 // for calibrating slide speed
            views[0].frame = f
            
            var f2 = views[1].frame
            f2.origin.y += 550.0 // for calibrating slide speed
            views[1].frame = f2
            
            /*
             var f3 = views[2].frame
             f3.origin.y -= 100.0
             views[2].frame = f3
             */
        }, completion: { finished in
            if !self.isStage3Started {
                // continue if only not aborted
                self.delegate?.shouldComplete(splash: self)
                self.isStage2Finished = true
                
                completion()
            }
        })
        
        // animate fade to bg parallax
        UIView.animate(withDuration: 2, animations: {
            self.overlayView.alpha = 0.65
        })
    }
    
    func stage3Animation() {
        if !self.isStage2Finished {
            self.delegate?.shouldComplete(splash: self)
            self.isStage2Finished = true
        }
        self.isStage3Started = true
        
        // animate scaling down logo
        self.logoImageViewConstraintWidth.constant *= 0.8
        UIView.animate(withDuration: 0.14, animations: {
            self.stage1View.layoutIfNeeded()
        }, completion: { finished in
            // animate scaling up logo
            self.logoImageViewConstraintWidth.constant = self.view.bounds.width * 3
            UIView.animate(withDuration: 0.1, animations: {
                self.stage1View.layoutIfNeeded()
            }, completion: { finished in
                // animate fade out
                UIView.animate(withDuration: 0.1, animations: {
                    self.view.alpha = 0
                }, completion: { _ in
                    self.view.alpha = 0
                    self.delegate?.didFinish(splash: self)
                })
            })
        })
    }
}
