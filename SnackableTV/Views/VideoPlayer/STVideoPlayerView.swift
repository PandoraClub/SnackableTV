//
//  STVideoPlayerView.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-13.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import Alamofire

protocol STVideoPlayerViewType {
    var isControlsHidden: Bool {get set}
    
    func play()
    func play(context: STVideoPlaybackContext?)
    func play(itemDetail: STVideoPlayableItemDetail, context: STVideoPlaybackContext?)
    func stop()
    
    func resume()
    func pause()
}

protocol STVideoPlayerViewDelegate: class {
    func played(context: STVideoPlaybackContext?)
    func playNext()
    
    func stopped(context: STVideoPlaybackContext?)
    func paused(context: STVideoPlaybackContext?)
    func resumed(context: STVideoPlaybackContext?)
    
    func didTapWatchMore()
    func showWifiSettingsAlert()
}

struct STVideoPlaybackContext {
    var content: STContent?
    var progressPercentage: Float?
}

class STVideoPlayerView: UIView, STVideoPlayerViewType {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var videoCanvasView: UIView!
    
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var progressBarView: STProgressBarView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var rotateButton: UIButton!
    @IBAction func rotateButtonTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var volumeButton: UIButton!
    @IBAction func volumeButtonTapped(_ sender: Any) {
    }
    @IBOutlet weak var pauseResumeButton: UIButton!
    @IBAction func pauseResumeButtonTapped(_ sender: Any) {
        // TODO: should not bind singleton to player instance like this
        guard let player = videoPlayer,
            !player.isStopped else { return }
        
        if player.isPaused() {
            self.resume()
        } else {
            self.pause()
        }
        isPlayerViewPaused = !isPlayerViewPaused
    }
    
    @IBOutlet weak var coverContainerView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverLengthLabel: UILabel!
    @IBOutlet weak var coverTitleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBAction func playButtonTapped(_ sender: Any) {
        guard let detail = playableItemDetail else { return }
        
        videoPlayer = STVideoPlayer.sharedInstance()
        self.play(itemDetail: detail, context: self.playbackContext)
    }
    
    @IBOutlet weak var watchMoreView: UIView!
    @IBOutlet weak var watchMoreTitleLabel: UILabel!
    @IBAction func watchMoreButtonTapped(_ sender: Any) {
        self.delegate?.didTapWatchMore()
    }
    @IBOutlet weak var watchMoreTimerProgressView: STProgressBarView!
    
    
    // play backs
    var videoPlayer: STVideoPlayer?
    weak var delegate: STVideoPlayerViewDelegate?
    var playableItemDetail: STVideoPlayableItemDetail?
    var playbackContext: STVideoPlaybackContext?
    
    // states
    var _isPlayerViewPaused: Bool = false
    var _isControlsHidden: Bool = true
    
    // gestures
    var _panGesture: UIPanGestureRecognizer?
    var _pBarLengthAtPanGestureBegin: CGFloat = 0
    var _isPanGestureInProgress: Bool = false
    var _autoDismissTimer: Timer?
    
    // watch more
    var isWatchMoreEnabled: Bool = false
    
    
    // MARK: life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        self.awake() // awakeFromNib not called if programmatically initialized, eg STVideoPlayerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "STVideoPlayerView", bundle: bundle)
        let contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.addSubview(contentView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.awake()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = self.bounds
    }
    
    func awake() {
        // add the missing contrainst between xib contentView to self
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.setNeedsUpdateConstraints()
        
        // self.translatesAutoresizingMaskIntoConstraints = true
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector( toggleShowOrHideControls(_:) ))
        self.contentView.addGestureRecognizer(tapGesture)
        
        _panGesture = UIPanGestureRecognizer(target: self, action: #selector( videoProgressChanged(_:) ))
        self.contentView.addGestureRecognizer(_panGesture!)
        _panGesture?.isEnabled = false // default disabled
        
        self.coverContainerView.isHidden = false
    }
    
    // instance methods
    
    func play() {
        if let detail = self.playableItemDetail {
            self.play(itemDetail: detail, context: self.playbackContext)
        }
    }
    
    func play(context: STVideoPlaybackContext?) {
        if let detail = self.playableItemDetail {
            self.play(itemDetail: detail, context: context)
        }
    }
    
    func play(itemDetail: STVideoPlayableItemDetail, context: STVideoPlaybackContext?) {
        if !isWifiAvailable { // Check wifi availability before playing video
            self.delegate?.showWifiSettingsAlert()
            return
        }
        
        stop() // stop old one before playing new one
        
        self.coverContainerView.isHidden = true
        self.isControlsHidden = false
        self.startAutoDismissTimer(withTimeout: 3.0)
        self.progressBarView.progressPercentage = 0.0
        self.playbackContext = context
        
        // set player
        videoPlayer = STVideoPlayer.sharedInstance()
        videoPlayer!.stDelegate = self
        
        var detail = itemDetail
        self.fetchVideoPackage(packagePath: itemDetail.packagePath) { (success, securityType) in
            guard success
                else { return }
            
            detail.drmSecurityType = securityType ?? ""
            self.videoPlayer?.play(itemDetail: detail, inView: self.videoCanvasView)
            self.delegate?.played(context: self.playbackContext)
        }
    }
    
    func stop() {
        guard videoPlayer?.isStarted ?? false else { return }
        
        videoPlayer?.stop()
        
        self.coverContainerView.isHidden = false
        self.isControlsHidden = true
        
        // update progress
        self.playbackContext?.progressPercentage = self.progressBarView.progressPercentage
        self.delegate?.stopped(context: self.playbackContext)
    }
    
    func resume() {
        videoPlayer?.resume()
        
        self.delegate?.resumed(context: playbackContext)
    }
    
    func pause() {
        self.playbackContext?.progressPercentage = self.progressBarView.progressPercentage
        videoPlayer?.pause()
        
        self.delegate?.paused(context: playbackContext)
    }
    
    var duration: CGFloat = 0 { // 🎓, from meta data, actual playback duration is not available until play()
        didSet {
            // 🎓, duration == 0 is LIVE stream
            progressBarView.isHidden = duration <= 0
            coverLengthLabel.isHidden = duration <= 0
            durationLabel.isHidden = duration <= 0
            
            coverLengthLabel.text = Int(duration).secondsToTimeString()
            durationLabel.text = "-" + Int(duration).secondsToTimeString()
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
            coverTitleLabel.text = title
        }
    }
    
    var isWifiAvailable: Bool { //Check wifi settings for the App
        let netManager = NetworkReachabilityManager()
        guard (netManager?.isReachable)! else { return false}
        if(netManager?.isReachableOnWWAN)! {
            if STSettings.isVideoOnWifiOnlyEnabled() {// Check in-app settings for wifi status
                return false
            }
        }
        return true
    }
    
    // for fetching 
    lazy var contentPackageRemote: STContentPackageRemoteType = {
        return STContentPackageRemote(remoteSession: nil)
    }()
}

extension STVideoPlayerView: STVideoPlayerDelegate {
    func videoEngine(_ videoEngine: AVEVideoEngine!, withCurrentTime currentTime: Float) {
        guard !_isPanGestureInProgress else {
            return
        }
        
        self.updateTimeRemain(fromCurrentTime: currentTime)
        
        let duration = (videoPlayer?.videoItem?.duration.floatValue ?? 0)
        let ratio = currentTime / duration
        self.progressBarView.progressPercentage = ratio
    }
    
    func videoEngine(_ videoEngine: AVEVideoEngine!, didFinishPlay finished: Bool) {
        self.playbackContext?.progressPercentage = 1
        // update progress
        guard let ctt = self.playbackContext?.content else { return }
        if let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator {
            syncCoordinator.watchHistoryProcessor.updateOrInsertWatchedContent(progressPercentage: 1, startedTime: nil,
                                                                               updatedTime: Date(),
                                                                               content: ctt, { (finished, watchedContent) in })
        }
        
        if self.isWatchMoreEnabled {
            // ignore FEED videos who does not link to Series Home
            guard let media = self.playbackContext?.content?.media else
            {
                self.delegate?.playNext()
                return
            }
            
            self.watchMoreTitleLabel.text = media.name
            self.watchMoreTimerProgressView.progressPercentage = 0.0
            self.watchMoreView.isHidden = false
            isControlsHidden = true
            
            UIView.animate(withDuration: 5.0, animations: {
                self.watchMoreTimerProgressView.progressPercentage = 1.0
            }, completion: { finished in
                self.watchMoreView.isHidden = true
                self.delegate?.playNext()
            })
        } else {
            self.delegate?.playNext()
        }
    }
}

