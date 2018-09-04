//
//  STSeriesTableViewController.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-12.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

fileprivate let kBellBlueColor = UIColor(red: 0.0/255.0, green: 136.0/255.0, blue: 255/255.0, alpha: 1)
fileprivate let kVideoCanvasViewHeight = 211.0 as CGFloat
fileprivate let kTableCellHeight = 93.0 as CGFloat

class STSeriesTableViewController: STCardViewController {
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var videoPlayerView: STVideoPlayerView!
    @IBOutlet weak var videoPlayerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoCanvasViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var watchButtton: ACBorderedButton!
    @IBOutlet weak var roundBorededView: ACBorderedView!
    @IBOutlet weak var watchAllButtonLabel: UILabel!
    
    var media: STMedia?
    var currentPlayIndex: Int? = 0
    fileprivate var fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
    fileprivate var _scrollDirection: STScrollDirection = .none
    fileprivate var _lastContentOffset: CGFloat = 0
    var tempAnimationContents: [STContent] = []
    var isDuringFirstTimeTableLoading = false

    @IBAction func watchButtonTapped(_ sender: ACBorderedButton) {
        if let content = self.fetchedContents.first {
            guard let package = content.contentPackages?.first
                else { return }
            
            let streamUrlString = (self.fetchedMedia?.url ?? "") + "/contents/\(content.id)/contentpackages/\(package.id)/manifest.m3u8"
            print("streamUrl: %@", streamUrlString)
            
            let playableItem = STVideoPlayableItemDetail(urlString: content.streamUrlString ?? "",
                                                         duration: Float(content.contentPackages?.first?.duration ?? 0),
                                                         packagePath: content.firstContentPackagePath ?? "")
            self.videoPlayerView.play(itemDetail: playableItem,
                                      context: STVideoPlaybackContext(content: content, progressPercentage: 0))
            sender.isHidden = true
            self.roundBorededView.isHidden = true
            
            currentPlayIndex = 1
            tableView.reloadData() //calls to show the cell selected state
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        videoPlayerView.delegate = self as? STVideoPlayerViewDelegate
        self.videoPlayerView.playButton.isHidden = true
        

        // orientation
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIDeviceOrientationDidChange, object: nil, queue: nil) { (note) in
            guard self.isViewLoaded && (self.view.window != nil) else { return }
            
           if UIDevice.current.orientation.isPortrait {
                // update player view
                self.videoPlayerHeightConstraint.constant = kVideoCanvasViewHeight
                self.videoCanvasViewHeightConstraint.constant = kVideoCanvasViewHeight
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.videoPlayerView.superview?.layoutIfNeeded()
                }, completion: { (finished) in
                })
                
                // update top bars
                self.cardDelegate?.request(forHeaderCollapse: STHeaderCollapseOption.collaspeTabBar(.full), context: nil)
                
            } else if UIDevice.current.orientation.isLandscape {
                // update player view
                self.videoPlayerHeightConstraint.constant = UIScreen.main.bounds.height
                self.videoCanvasViewHeightConstraint.constant = UIScreen.main.bounds.height
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.videoPlayerView.superview?.layoutIfNeeded()
                }, completion: { (finished) in
                })
                
                // update top bars
                self.cardDelegate?.request(forHeaderCollapse: STHeaderCollapseOption.collaspeAll, context: nil)
               
            } else {}
        }
        
        /* // The below commented code is moved to ViewDidAppear() to implement animation
        if let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator
        {
            syncCoordinator.syncAll({ (success, synced, error) in
                if let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator
                {
                    self.fetchedResultsController = NSFetchedResultsController<NSManagedObject>.instantiate(entityName: "STMedia",
                                                                                                            predicate: NSPredicate(format: "id = \(self.media!.id as Int64)"),
                                                                                                            managedObjectContext: syncCoordinator.coreDataStack.mainManagedObjectContext,
                                                                                                            fetchOffset: 0,
                                                                                                            fetchLimit: 0,
                                                                                                            sortDescriptors: [],
                                                                                                            delegate: nil)
                    do {
                        try self.fetchedResultsController?.performFetch()
                        
                        let media = self.fetchedMedia
                        guard media != nil else { return }
                    
                        let content = (media?.contents?.array as? [STContent]) ?? []
                        let filteredResults = content.filter() { $0.watchedContent != nil } // filtered by watchedContent
                        if filteredResults.count > 0 { self.watchAllButtonLabel.text = "CONTINUE" }
                        else { self.watchAllButtonLabel.text = "WATCH ALL" }
                        
                        /*
                        let mediaId = media?.id
                        let mediaDesc = media?.desc
                         */
                        
                        self.videoPlayerView.coverTitleLabel.text = media?.name
                        let snackCount : Int? = media?.contents?.count

                        self.videoPlayerView.coverLengthLabel.textColor = UIColor(red: 11/255.0, green: 113/255.0, blue: 255/255.0, alpha: 1)
                        self.videoPlayerView.coverLengthLabel.text = "\(snackCount!) SNACKS"
                        
                        self.videoPlayerView.coverImageView.contentMode = .scaleAspectFill
                        let keyartUrlStr = media?.images?.filter{ $0.type ~= "thumbnail" }.first?.url(withSize: self.videoPlayerView.coverImageView.bounds.size)
                        
                        self.videoPlayerView.coverImageView.contentMode = .center
                        self.videoPlayerView.coverImageView.sdSetImage(withString: keyartUrlStr, scaleToFillWhenFinished: true) { (_, _, _, _) in
                        }

                        self.tableView.reloadData() // reload with animation does not render cell's subviews correctly
                        
                    } catch {}
                }
            })
        }*/

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cardDelegate?.request(forHeaderCollapse: .none, context: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        guard self.fetchedMedia?.contents?.count == 0 // ignore if not first time loading
//            else { return }
        
        if let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator
        {
            syncCoordinator.syncAll({ (success, synced, error) in
                if let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator
                {
                    self.fetchedResultsController = NSFetchedResultsController<NSManagedObject>.instantiate(entityName: "STMedia",
                                                                                                            predicate: NSPredicate(format: "id = \(self.media!.id as Int64)"),
                                                                                                            managedObjectContext: syncCoordinator.coreDataStack.mainManagedObjectContext,
                                                                                                            fetchOffset: 0,
                                                                                                            fetchLimit: 0,
                                                                                                            sortDescriptors: [],
                                                                                                            delegate: nil)
                    do {
                        try self.fetchedResultsController?.performFetch()
                        
                        let media = self.fetchedMedia
                        guard media != nil else { return }
                        
                        let content = (media?.contents?.array as? [STContent]) ?? []
                        let filteredResults = content.filter() { $0.watchedContent != nil } // filtered by watchedContent
                        if filteredResults.count > 0 { self.watchAllButtonLabel.text = "CONTINUE" }
                        else { self.watchAllButtonLabel.text = "WATCH ALL" }
                        
                        /*
                         let mediaId = media?.id
                         let mediaDesc = media?.desc
                         */
                        
                        self.videoPlayerView.coverTitleLabel.text = media?.name
                        let snackCount : Int? = media?.contents?.count
                        
                        self.videoPlayerView.coverLengthLabel.textColor = UIColor(red: 11/255.0, green: 113/255.0, blue: 255/255.0, alpha: 1)
                        self.videoPlayerView.coverLengthLabel.text = "\(snackCount!) SNACKS"
                        
                        self.videoPlayerView.coverImageView.contentMode = .scaleAspectFill
                        let keyartUrlStr = media?.images?.filter{ $0.type ~= "thumbnail" }.first?.url(withSize: self.videoPlayerView.coverImageView.bounds.size)
                        
                        self.videoPlayerView.coverImageView.contentMode = .center
                        self.videoPlayerView.coverImageView.sdSetImage(withString: keyartUrlStr, scaleToFillWhenFinished: true) { (_, _, _, _) in
                        }
                        
                        self.watchButtton.isHidden = false
                        self.roundBorededView.isHidden = false
                        
                        if self.fetchedContents.count > 1 { // only reload table if there are cells
                            
                            var tDelay: Double = 0
                            let n = min(8, self.fetchedContents.count) // animate only 8 rows
                            for (idx, c) in self.fetchedContents.enumerated() {
                                guard idx > 0 else {
                                    self.tempAnimationContents.append(c)
                                    continue
                                }
                                guard idx < n
                                    else { return }
                                
                                self.isDuringFirstTimeTableLoading = true
                                
                                delay(tDelay, closure: {
                                    self.tableView.beginUpdates()
                                    self.tempAnimationContents.append(c)
                                    self.tableView.insertRows(at: [IndexPath(row: idx-1, section: 0)], with: .none)
                                    self.tableView.endUpdates()
                                    
                                    if idx == n - 1 {
                                        self.isDuringFirstTimeTableLoading = false
                                        self.tempAnimationContents = []
                                        self.tableView.reloadData() // let table view know the real count, otherwise crash
                                    }
                                })
                                tDelay += 0.09
                            }
                        }
                        
                        //self.tableView.reloadData() // reload with animation does not render cell's subviews correctly
                        
                    } catch {}
                }
            })
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.videoPlayerView.stop()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscape]
    }
    
    // MARK: instance methods
    
    var fetchedMedia: STMedia? {
        let medias = (self.fetchedResultsController?.fetchedObjects as? [STMedia]) ?? []
        return medias.first
    }
    
    var fetchedContents: [STContent] {
        let medias = (self.fetchedResultsController?.fetchedObjects as? [STMedia]) ?? []
        
        guard let media = medias.first,
            let contents = media.contents
            else { return [] }
        
        let results = (contents.array as? [STContent]) ?? []
        let sortedResults = results.sorted(by: { $0.episode < $1.episode }) // sorted by episode number
        return sortedResults
    }
    
    func prepareVideoPlay(withContent content: STContent) {
        
        guard let package = content.contentPackages?.first
            else { return }
        // TODO: refactor
        
        self.videoPlayerView.title = content.name?.uppercased()
        let d = package.duration ?? 0
        self.videoPlayerView.duration = CGFloat(d)
        
        let streamUrlString = (self.self.fetchedMedia?.url ?? "") + "/contents/\(content.id)/contentpackages/\(package.id)/manifest.m3u8"
        
        let playableItem = STVideoPlayableItemDetail(urlString: streamUrlString,
                                                     duration: Float(package.duration ?? 0),
                                                     packagePath: content.firstContentPackagePath ?? "")
        self.videoPlayerView.playableItemDetail = playableItem

        self.videoPlayerView.coverImageView.contentMode = .scaleAspectFill
        let keyartUrlStr = content.images?.filter{ $0.type ~= "thumbnail" }.first?.url(withSize: self.videoPlayerView.coverImageView.bounds.size)
        
        self.videoPlayerView.coverImageView.contentMode = .center
        self.videoPlayerView.coverImageView.sdSetImage(withString: keyartUrlStr, scaleToFillWhenFinished: true) { (_, _, _, _) in
        }
    }
    
    func update(watchedContentProgress progressPercentage: Float?,
                startedTime: Date?,
                updatedTime: Date?,
                content: STContent?,
                _ completion: ( (_ success: Bool, _ syncedObject: Any?) -> () )? = nil)
    {
        guard let pp = progressPercentage,
            let ctt = content else { return }
        
        if let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator {
            syncCoordinator.watchHistoryProcessor.updateOrInsertWatchedContent(progressPercentage: pp, startedTime: startedTime,
                                                                               updatedTime: updatedTime,
                                                                               content: ctt, { (finished, watchedContent) in
                                                                                    if let c = completion {
                                                                                        c(finished, watchedContent)
                                                                                    }
                                                                                })
        }
    }
   
}

extension STSeriesTableViewController: STVideoPlayerViewDelegate {
    func didTapWatchMore() {
        
    }

    func played(context: STVideoPlaybackContext?) {
        self.cardDelegate?.request(forHeaderCollapse: STHeaderCollapseOption.collaspeAll, context: nil)
        
        self.update(watchedContentProgress: 0,
                    startedTime: Date(),
                    updatedTime: nil,
                    content: context?.content)
    }
    
    func playNext() {
        self.cardDelegate?.request(forHeaderCollapse: STHeaderCollapseOption.collaspeAll, context: nil)
        
        let objs = self.fetchedContents
        
        guard let cIdx = currentPlayIndex, cIdx < objs.count
            else { return }
        
        // save progress for last played content
        self.update(watchedContentProgress: self.videoPlayerView.playbackContext?.progressPercentage,
                    startedTime: nil,
                    updatedTime: Date(),
                    content: self.videoPlayerView.playbackContext?.content)
        
        let content = objs[cIdx]
        self.prepareVideoPlay(withContent: content)
        self.videoPlayerView.playbackContext = STVideoPlaybackContext(content: content, progressPercentage: 0)
        self.videoPlayerView.play()
        
        currentPlayIndex = cIdx + 1
        
        tableView.reloadData() //calls to show the cell selected state
    }
    
    func stopped(context: STVideoPlaybackContext?) {
        self.cardDelegate?.request(forHeaderCollapse: STHeaderCollapseOption.collaspeTabBar(.normal), context: nil)
        
        self.update(watchedContentProgress: context?.progressPercentage,
                    startedTime: nil,
                    updatedTime: Date(),
                    content: context?.content, { finished, _ in
                        if finished {
                            self.tableView.reloadData() // update progress
                        }
                    })
    }
    
    func paused(context: STVideoPlaybackContext?) {
        self.cardDelegate?.request(forHeaderCollapse: STHeaderCollapseOption.collaspeTabBar(.normal), context: nil)
        
        self.update(watchedContentProgress: context?.progressPercentage,
                    startedTime: nil,
                    updatedTime: Date(),
                    content: context?.content)
    }
    
    func resumed(context: STVideoPlaybackContext?) {
        self.cardDelegate?.request(forHeaderCollapse: STHeaderCollapseOption.collaspeAll, context: nil)
    }
    
    func showWifiSettingsAlert() {
        let alert = UIAlertController(title: kAppNameForAlertTitle, message: kWifiAlertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension STSeriesTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard !self.isDuringFirstTimeTableLoading else {
            return max(0, self.tempAnimationContents.count)
        }
        
        let contents = self.fetchedContents
        return max(0, contents.count+1) //first cell would be header cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*let isHeaderCell = (indexPath.row == 0) /commented to have more margin space for Headercell
        if isHeaderCell {
            return 93.0
        } else {
            return 93.0
        }*/
        return kTableCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isHeaderCell = (indexPath.row == 0)
        let celId = isHeaderCell ? "kSeriesHeaderTableCell" : "kWatchHistoryTableCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: celId)!
        
        if isHeaderCell {
            let headerCell = cell as! STSeriesHeaderTableCell
            
            let medias = (self.fetchedResultsController?.fetchedObjects as? [STMedia]) ?? []
            guard medias.first != nil else { return headerCell}
            let media = medias.first
            headerCell.label.text = media?.shortDesc
        } else {
            let mainCell = cell as! STWatchHistoryTableViewCell
            mainCell.selectionStyle = .none //to remove the white/grey bg color
            if mainCell.isSelected || currentPlayIndex! == indexPath.row{
                mainCell.backgroundColor = kBellBlueColor
            }else{
                mainCell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.black : UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1)
            }
            
            let contents = self.fetchedContents
            if contents.count == 0 { return mainCell }
            let item = contents[indexPath.row-1] //start from the previous item as the first cell would be headercell
            mainCell.titleLabel.text = item.name?.uppercased()
            
            let d = (item.contentPackages?.first)?.duration
            let dSeconds = Int(d ?? 0)
            mainCell.durationLabel.text = String(format: "%@", dSeconds.secondsToTimeString())
            
            let progressPercent = item.watchedContent?.progressPercentage?.floatValue ?? 0
            mainCell.progressBarView.progressPercentage = progressPercent
            
            if progressPercent >= 1 { // dim the title if finished watching this video
                mainCell.isFinishedWatching = true
            }
            
            mainCell.imgView.sdSetImage(withString: item.images?.first?.url(withSize: CGSize(width: 130, height: 73)), scaleToFillWhenFinished: true)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 { return } //return if user taps on first cell (Headercell)
        let contents = self.fetchedContents
        let content = contents[indexPath.row-1]
        guard (content.contentPackages?.first) != nil
            else { return }
        
        self.prepareVideoPlay(withContent: content)
        self.videoPlayerView.play(context: STVideoPlaybackContext(content: content, progressPercentage: 0))

        currentPlayIndex = indexPath.row
        
        tableView.reloadData() //calls to show the cell selected state
        
        self.watchButtton.isHidden = true
        self.roundBorededView.isHidden = true
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // animate new cell when first loaded, or scrolling up
        if (_scrollDirection == .none && self.isDuringFirstTimeTableLoading) ||
            _scrollDirection == .up
        {
            // 1. set the initial state of the cell
            cell.alpha = 0
            let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -200, 0) //slide from the bottom
            cell.layer.transform = transform
            
            // 2. UIView animation method to change to the final state of the cell
            UIView.animate(withDuration: 0.5, animations: {
                cell.alpha = 1.0
                cell.layer.transform = CATransform3DIdentity
            })
        }
    }
}

extension STSeriesTableViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentPlayIndex! > 0 { return } //show page-art scaling only when video not playing
        if scrollView.contentOffset.y < 0 {
            let y = abs(scrollView.contentOffset.y)
            videoCanvasViewHeightConstraint.constant = kVideoCanvasViewHeight + y
        }
        
        // ignore scrolling within bounce regions
        guard scrollView.contentOffset.y >= 0,
            scrollView.contentOffset.y <= scrollView.contentSize.height - scrollView.bounds.height else
        {
            return
        }
        
        // set scroll direction
        if (_lastContentOffset < scrollView.contentOffset.y) {
            // scroll up
            _scrollDirection = .up
        } else if (_lastContentOffset > scrollView.contentOffset.y) {
            // scroll down
            _scrollDirection = .down
        }
        // update the new position acquired
        _lastContentOffset = scrollView.contentOffset.y
        
        
        // hide tabs bar
        switch _scrollDirection {
        case .up:
            self.cardDelegate?.request(forHeaderCollapse: STHeaderCollapseOption.collaspeTabBar(.normal), context: nil)
        case .down:
            self.cardDelegate?.request(forHeaderCollapse: .none, context: nil)
        default: return
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if _scrollDirection == .up {
            // Determine which table cell the scrolling will stop on.
            let cellHeight: CGFloat = kTableCellHeight
            var cellIndex: NSInteger
            cellIndex = NSInteger(floor (targetContentOffset.pointee.y / cellHeight))
            
            // Round to the next cell if the scrolling will stop over halfway to the next cell.
            if ((targetContentOffset.pointee.y - (floor(targetContentOffset.pointee.y / cellHeight) * cellHeight)) > cellHeight) {
                cellIndex += 1;
            }
            
            // Adjust stopping point to exact beginning of cell.
            targetContentOffset.pointee.y =  CGFloat(cellIndex) * cellHeight
            
        }
    }

}
