//
//  STVideoPlayerView+UI.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-26.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

extension STVideoPlayerView {
    
    var isPlayerViewPaused: Bool {
        get {
            return _isPlayerViewPaused
        }
        set {
            _isPlayerViewPaused = newValue
            
            if isPlayerViewPaused {
                self.pauseResumeButton.setImage(UIImage(named:"playerPlay"), for: .normal)
            } else {
                self.pauseResumeButton.setImage(UIImage(named:"playerPause"), for: .normal)
            }
        }
    }
    
    var isControlsHidden: Bool {
        get {
            return _isControlsHidden
        }
        set {
            _isControlsHidden = newValue
            
            controlsView.isHidden = isControlsHidden
            
            if !isControlsHidden {
                // set play button state
                isPlayerViewPaused = videoPlayer?.isPaused() ?? false
            }
        }
    }
    
    func updateTimeRemain(fromCurrentTime ct: Float) {
        let duration = (videoPlayer?.videoItem?.duration.floatValue ?? 0)
        let countdown = Int(duration - ct)
        durationLabel.text = "-" + countdown.secondsToTimeString()
    }
    
    func setControls(hidden: Bool, animated: Bool) {
        guard animated else {
            self.isControlsHidden = hidden
            return
        }
        
        self.isUserInteractionEnabled = false // prevent interruption
        
        let endAlpha: CGFloat = hidden ? 0.0 : 1.0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.controlsView.alpha = endAlpha
        }, completion: { finished in
            self.controlsView.alpha = endAlpha
            self.isControlsHidden = hidden
            self.controlsView.alpha = 1.0 // reset alpha
            self.isUserInteractionEnabled = true
        })
    }
}

// gestures
extension STVideoPlayerView {
    
    func toggleShowOrHideControls(_ target: Any?) {
        if videoPlayer?.isStarted ?? false {
            self.isControlsHidden = !self.isControlsHidden
            _panGesture?.isEnabled = !self.isControlsHidden
            
            if !self.isControlsHidden { // if shown, start fade countdown
                self.startAutoDismissTimer(withTimeout: 3.0)
            }
        }
    }
    
    func videoProgressChanged(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began {
            _isPanGestureInProgress = true
            
            _pBarLengthAtPanGestureBegin = self.progressBarView.fillingLength
            if !isControlsHidden {
                self.endAutoDismissTimer()
            }
        } else if gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
            
            let tX = translation.x
            self.progressBarView.fillingLength = _pBarLengthAtPanGestureBegin + tX / kPanGestureScale
            
            
            let progressPercentage = self.progressBarView.progressPercentage
            let duration = (videoPlayer?.videoItem?.duration.floatValue ?? 0)
            let seekTo = Float(duration * progressPercentage)
            self.updateTimeRemain(fromCurrentTime: seekTo)
            
        } else if gestureRecognizer.state == .ended {
            let progressPercentage = self.progressBarView.progressPercentage
            
            let duration = (videoPlayer?.videoItem?.duration.floatValue ?? 0)
            let seekTo = duration * progressPercentage
            if seekTo <= duration {
                if let vp = videoPlayer, // pause if not paused, otherwise resume not working
                    !vp.isPaused()
                {
                    vp.pause()
                }
                
                videoPlayer?.resume(atTime: CGFloat(seekTo))
                self.isPlayerViewPaused = false
            }
            if !isControlsHidden {
                self.startAutoDismissTimer(withTimeout: 3.0)
            }
            _isPanGestureInProgress = false
        }
    }
}

fileprivate let kPanGestureScale: CGFloat = 2.0

// fade timer
extension STVideoPlayerView {
    // following calls to this method resets
    func startAutoDismissTimer(withTimeout seconds: Double) {
        if _autoDismissTimer != nil {
            self.endAutoDismissTimer()
        }
        
        _autoDismissTimer = Timer(timeInterval: seconds, target: self, selector: #selector(autoDimissTimerTriggered), userInfo: nil, repeats: false)
        RunLoop.current.add(_autoDismissTimer!, forMode: RunLoopMode.commonModes)
    }
    
    func endAutoDismissTimer() {
        _autoDismissTimer?.invalidate()
        _autoDismissTimer = nil
    }
    
    func autoDimissTimerTriggered() {
        self.setControls(hidden: true, animated: true)
        self.endAutoDismissTimer()
    }
}
