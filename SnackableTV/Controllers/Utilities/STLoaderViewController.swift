//
//  STLoaderViewController.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-03.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class STLoaderViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    static var sharedInstance: STLoaderViewController? = nil
    
    static func instantiate() -> STLoaderViewController {
        let loaderVC = STStoryboardFactory.miscStoryboard.instantiateViewController(withIdentifier: "loaderVC") as! STLoaderViewController
        loaderVC.modalTransitionStyle = .crossDissolve
//        loaderVC.modalPresentationStyle = .overCurrentContext
        return loaderVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /*
    func repeatPulseAnimation () {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: { [weak self] in // enlarge cab icon
            self?.imageView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { [weak self] (completed) in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self?.imageView.transform = CGAffineTransform(scaleX: 1, y: 1) // shrink cab icon
            }) { (completed) in
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { // enlarge circle
                    self?.circleView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    
                    // animate alpha
                    self?.circleView.alpha = 1
                    
                }) { (completed) in
                    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: { // fade out
                        self?.circleView.transform = CGAffineTransform(scaleX: 2, y: 2)
                        
                        // animate alpha
                        self?.circleView.alpha = 0
                        
                    }) { (completed) in
                        self?.circleView.alpha = 0
                        self?.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self?.perform(#selector(self?.repeatPulseAnimation), with: nil, afterDelay: 0.2)
                    }
                }
            }
        }
        
    }
    */
}
