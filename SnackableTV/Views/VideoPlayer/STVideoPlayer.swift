//
//  STVideoPlayer.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-11.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

struct STVideoPlayableItemDetail {
    var urlString: String
    var duration: Float
    var drmSecurityType: String = ""
    var packagePath: String
    
    init(urlString: String, duration: Float, packagePath: String) {
        self.urlString = urlString
        self.duration = duration
        self.packagePath = packagePath
    }
}

protocol STVideoPlayerDelegate: class {
    func videoEngine(_ videoEngine: AVEVideoEngine!, withCurrentTime currentTime: Float)
    func videoEngine(_ videoEngine: AVEVideoEngine!, didFinishPlay finished: Bool)
}

protocol STVideoPlayerType {
    var videoItem: AVEVideoItem? {get}
    func play(itemDetail: STVideoPlayableItemDetail, inView view: UIView)
    
    var isStarted: Bool {get}
    var isStopped: Bool {get}
}

class STVideoPlayer: AVEVideoEngine {
    
    var detailItem =  [ "_KAXISLIVE_": 0,
                        "_KCONTENTURL_": "",
                        "_KDESCRIPTION_": "",
                        "_KDURATION_": "0",
                        "_KMEDIAID_": 0,
                        "_KPACKAGEID_": 0,
                        "_KSECUREFEED_": "adobe-drm",
                        "_KSEEKTIME_": 0,
                        "_KSTREAMTYPE_": "VOD",
                        "_KTITLE_": "",
                        "_kVMEDIADFPNAME_": "",
                        "isMovieType": 0
                    ] as [String : Any]
    
    fileprivate var _videoItem: AVEVideoItem?
    weak var stDelegate: STVideoPlayerDelegate?
    var playableItemDuration: Float = 0
    
    fileprivate let sharedStreamSense = CSStreamSense() // not needed, except by stupid AVEEngine delegate callbacks

    // custom hack
    func hideDefaultControls(inPlayerCanvasView view: UIView) {
        view.subviews.forEach { (v1) in
            print("v1 %@", v1)
            if NSStringFromClass(type(of:v1)) == "AVEPlayerControl" {
                print("found AVEPlayerControl view")
            }
            v1.subviews.forEach { (v2) in
                print("v2 %@", v2)
                if NSStringFromClass(type(of:v2)) == "PTMediaPlayerView" {
                    print("found PTMediaPlayerView view")
                } else {
                    v2.isHidden = true
                }
                
                v2.subviews.forEach { (v3) in
                    print("v3 %@", v3)
                }
            }
        }
    }
}

extension STVideoPlayer: STVideoPlayerType {
    var videoItem: AVEVideoItem? {
        return self._videoItem
    }

    func play(itemDetail: STVideoPlayableItemDetail, inView view: UIView) {
        // video play back
        let kOmnitureProperty71 = "OmnitureProperty71"
        
        self.setMessageDictionary(["403.73": "Concurrency problem",
                                   "403.72": "Geo-restriction problem"])
        self.setObject("Home Page", forKey: kOmnitureProperty71)
        self.language = "en" // Todo
        self.userConnectionState = BMUserSetting.wifiAndWWAN
        
        self.delegate = self
        
        detailItem["_KCONTENTURL_"] = itemDetail.urlString
        detailItem["_KDURATION_"] = String(format: "%f", itemDetail.duration)
        detailItem["_KSECUREFEED_"] = itemDetail.drmSecurityType
        
        _videoItem = self.prepareVideoStreamForPlayback(using: detailItem, currentView: { () -> UIView? in
            return view
        })
        
        self.hideDefaultControls(inPlayerCanvasView: view)
    }
    
    var isStarted: Bool {
        return !self.isStopped
    }
    
    var isStopped: Bool {
        if !self.isPlaying(),
            !self.isPaused()
        {
            return true
        } else {
            return false
        }
    }
}

// MARK: Required Video Player Delegates

extension STVideoPlayer: AVEVideoDelegate {
    
    func videoEngineAdUnitName(_ videoEngine: AVEVideoEngine!) -> String! { return "NoAdUnitName" }
    
    func videoEngineAdMasterTagName(_ videoEngine: AVEVideoEngine!) -> String! { return "NoAdMasterTagName" }
    
    func videoEngineControllerName(_ videoEngine: AVEVideoEngine!) -> String! {
        return "SnackableTV_VideoPlayer"
    }
    
    func videoEngineControllerVersion(_ videoEngine: AVEVideoEngine!) -> String! {
        return String(format: "%d", AppConfiguration.version())
    }
    
    func videoEngine(_ videoEngine: AVEVideoEngine!, exitButtonWasSelected button: UIButton!) {}
    
    func videoEngineWillPresentAdClickThrough(_ videoEngine: AVEVideoEngine!) -> UIViewController! { return nil }
    
    func videoEngine(withBrandLogo videoEngine: AVEVideoEngine!) -> UIImage! {
        return nil
    }
    
    func videoEngineSharingEnabled(_ videoEngine: AVEVideoEngine!) -> Bool {
        return false
    }
    
    func videoEngineSharingContent(_ videoEngine: AVEVideoEngine!) -> BMSharingItems! {
        return nil
    }
    
    func videoEngineWillPresentSharingController(_ videoEngine: AVEVideoEngine!) -> UIViewController! {
        return nil
    }
    
    func videoEngineWithActivityIndicatorType() -> BMActivityIndicatorType {
        return .crave
    }
    
    func streamSense() -> CSStreamSense! { // though not required delegate, crash if not implemented
        return sharedStreamSense
    }
    
    func useGoogleIMA() -> Bool { // though not required delegate, crash if not implemented
        return false
    }
    
    // MARK: optional delegates
    
    func videoEngine(_ videoEngine: AVEVideoEngine!, withCurrentTime currentTime: NSNumber!) {
        stDelegate?.videoEngine(videoEngine, withCurrentTime: currentTime.floatValue)
    }
    
    func videoEngineHideFastForward(_ videoEngine: AVEVideoEngine!) -> Bool {
        return true
    }
    
    func videoDidFinishPlaying(_ videoEngine: AVEVideoEngine!) {
        self.stDelegate?.videoEngine(self, didFinishPlay: true)
        // stay put or play next
    }
    
    func videoEngineVideoWasResumed(_ videoEngine: AVEVideoEngine!) -> Bool {
        if let seekTime = detailItem["kVideoEngineAxisSeekTime"] as? Float {
            return seekTime > 0
        } else {
            return false
        }
    }
    
    func metadataUpdateRateForLiveVideo() -> TimeInterval {
        return 2.0
    }
    
    func shouldDisplayUpNext() -> Bool {
        return false
    }
    
    func videoEngineRequestUpNextContent(_ videoEngine: AVEVideoEngine!) {
        
    }
    
    func playNextEpisode() {
        
    }
    
    func timeRemainingForUpNext() -> CGFloat {
        return 0; // to hide "Up Next"
    }
    
    func shouldDisplayClosedCaption() -> Bool {
        return true
    }
    
    // Reachability
    func playerHandlesReachability() -> Bool {
        return true
    }
    
    func brandColor() -> UIColor! {
        return UIColor.green
    }
}
