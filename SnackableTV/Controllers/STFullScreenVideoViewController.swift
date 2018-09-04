//
//  STFullScreenVideoViewController.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-05-04.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class STFullScreenVideoViewController: UIViewController {

    @IBAction func rightBarButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var videoPlayerView: STVideoPlayerView!
    @IBOutlet weak var videoPlayerHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(videoPlayerView)
        
        // orientation
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIDeviceOrientationDidChange, object: nil, queue: nil) { (note) in
            guard self.isViewLoaded && (self.view.window != nil) else { return }
            
            if UIDevice.current.orientation.isPortrait {
                // update player view
                self.videoPlayerHeightConstraint.constant = 211
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.videoPlayerView.superview?.layoutIfNeeded()
                }, completion: { (finished) in
                })
                self.videoPlayerView.rotateButton.isHidden = false
                
//                // update top bars
//                self.cardDelegate?.request(forHeaderCollapse: STHeaderCollapseOption.none, context: nil)
            } else if UIDevice.current.orientation.isLandscape {
                // update player view
                self.videoPlayerHeightConstraint.constant = UIScreen.main.bounds.height
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.videoPlayerView.superview?.layoutIfNeeded()
                }, completion: { (finished) in
                })
                self.videoPlayerView.rotateButton.isHidden = true
                
//                // update top bars
//                self.cardDelegate?.request(forHeaderCollapse: STHeaderCollapseOption.collaspeAll, context: nil)
            } else {}
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPlayerView.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.videoPlayerView.stop()
    }
}
