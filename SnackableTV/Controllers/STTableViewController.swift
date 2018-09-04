//
//  STTableViewController.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-12.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

fileprivate let kFetchSize: Int = 999 // only load one page now to maintain order accuracy

class STTableViewController: STCardViewController {

    @IBOutlet weak var videoPlayerView: STVideoPlayerView!
    @IBOutlet weak var videoPlayerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoPopupViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoPopupView: UIView!
    @IBOutlet weak var playingVideoTitleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
    
    var currentPlayIndex: Int? = 0
    fileprivate var _lastContentOffset: CGFloat = 0
    fileprivate var _scrollDirection: STScrollDirection = .none
    
    var contents: [STContent] = []
    var tempAnimationContents: [STContent] = []
    var isDuringFirstTimeTableLoading = false
    
    // MARK: life cycles 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0) //to fix the last cell cut off issue
        
        videoPlayerView.delegate = self
        videoPlayerView.isWatchMoreEnabled = true
        
        self.videoPopupViewHeightConstraint.constant = 0
        self.videoPopupView.backgroundColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1)
        self.videoPlayerView.bringSubview(toFront: self.videoPopupView)
        self.videoPlayerView.layoutIfNeeded()
        
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
                
                // update top bars
                self.cardDelegate?.request(forHeaderCollapse: STHeaderCollapseOption.none, context: nil)
            } else if UIDevice.current.orientation.isLandscape {
                // update player view
                self.videoPlayerHeightConstraint.constant = UIScreen.main.bounds.height
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.videoPlayerView.superview?.layoutIfNeeded()
                }, completion: { (finished) in
                })
                self.videoPlayerView.rotateButton.isHidden = true
                
                // update top bars
                self.cardDelegate?.request(forHeaderCollapse: STHeaderCollapseOption.collaspeAll, context: nil)
            } else {}
        }
    }
    
    var isLoaderShown: Bool = true {
        didSet {
            if !isLoaderShown {
                if let cell = tableView.cellForRow(at: IndexPath(row: 0, section:
                    TableSectionType.loaderCell.rawValue)) as? STLoaderTableCell
                {
                    cell.activityIndicator.stopAnimating()
                }
            }
            tableView.reloadData()
        }
    }
    
    private func fetchLocal(start: Int, size: Int = kFetchSize) -> [STContent] {
        var localFetches: [STContent] = []
        
        if let collectionId = self.collectionId,
            let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator
        {
            self.fetchedResultsController = NSFetchedResultsController<NSManagedObject>
                .instantiate(entityName: "STCollection",
                             predicate: NSPredicate(format: "id == \(collectionId)"),
                             managedObjectContext: syncCoordinator.coreDataStack.mainManagedObjectContext,
                             fetchOffset: 0,
                             fetchLimit: 0,
                             sortDescriptors: [],
                             delegate: nil)
            do {
                try self.fetchedResultsController?.performFetch()
                
//                let fContents = self.fetchedContents
                let objs = (self.fetchedResultsController?.fetchedObjects as? [STCollection]) ?? []
                guard let collection = objs.first,
                    let contents = collection.contents
                    else { return [] }
                let fContents = (contents.array as? [STContent]) ?? []

                if start < fContents.count {
                    let end = min(fContents.count, start+size)
                    let tmp: ArraySlice<STContent> = fContents[start..<end]
                    localFetches = Array(tmp)
                } else {
                    localFetches = []
                }
                _ = localFetches.filter {$0.watchedContent == nil} // filter out watched ones
            } catch {}
        }
        return localFetches
    }
    
    func fetchMoreItems(completion: @escaping (_ successful: Bool, _ isExhausted: Bool) -> () ) {
        let startIndex = contents.count
//        let localFetchedTrips = self.fetchLocal(start: startIndex)
//        
//        if localFetchedTrips.count > 0 { // local records are not exhausted
//            contents.append(contentsOf: localFetchedTrips)
//            completion(true, false)
//        } else {
            guard let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator
                else { return }
            
            guard let collectionId = self.collectionId
                else { return }
            
            let path = "/collections/" + collectionId.toString
            let orderParam = "" // "$sort=BroadcastDate&$order=desc"
            let page = startIndex / kFetchSize + 1 // page start from 1
            let params = "&$top=\(kFetchSize)&$page=\(page)&" + orderParam
            syncCoordinator.contentProcessor.fetchStoreContents(byPath: path, params: params, relationshipId: collectionId, { (success, synced) in
                DispatchQueue.main.async {
                    guard let syncedContents = synced as? [STJsonContent] else
                    {
                        completion(false, false)
                        return
                    }
                    
                    var exhausted = false
                    if startIndex >= syncedContents.count {
                        exhausted = true
                    } else {
                        if success {
//                            self.contents.append(contentsOf: self.fetchLocal(start: startIndex))
                            var cs = self.fetchLocal(start: startIndex)
                            let remoteCs = syncedContents.map {$0.id}
                            cs.sort(by: {
                                let idx0 = remoteCs.index(of: $0.id) ?? 0
                                let idx1 = remoteCs.index(of: $1.id) ?? 0
                                return idx0 < idx1
                            })
                            self.contents = cs
                        } else {
                            log(message: "fetch more failed")
                        }
                    }
                    completion(success, exhausted)
                }
            })
//        }
    }
    
    func fetchMore() {
        self.fetchMoreItems { (success, isExhausted) in
            if isExhausted {
                // remote records are exhausted
                self.isLoaderShown = false
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard self.contents.count == 0 // ignore if not first time loading
            else { return }
        
        self.fetchMoreItems { (_, _) in
            if let f = self.contents.first {
                self.prepareVideoPlay(withContent: f)
            }
            
            if self.contents.count > 1 { // only reload table if there are cells
                
                var tDelay: Double = 0
                let n = min(8, self.contents.count) // animate only 8 rows
                for (idx, c) in self.contents.enumerated() {
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
                        self.tableView.insertRows(at: [IndexPath(row: idx - 1, section: 0)], with: .none)
                        self.tableView.endUpdates()
                        
                        if idx == n - 1 {
                            self.isDuringFirstTimeTableLoading = false
                            self.tempAnimationContents = []
                            self.tableView.reloadData() // let table view know the real count, otherwise crash
                        }
                    })
                    tDelay += 0.09
                }
            } else {
                self.cardDelegate?.request(forLoaderToShow: false, context: nil)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // stop video player if otherwise
        self.videoPlayerView.stop()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscape]
    }
    
    // MARK: instance methods
    var fetchedCollection: STCollection? {
        let objs = (self.fetchedResultsController?.fetchedObjects as? [STCollection]) ?? []
        return objs.first
    }
    
//    var fetchedContents: [STContent] {
//        let objs = (self.fetchedResultsController?.fetchedObjects as? [STCollection]) ?? []
//        
//        guard let collection = objs.first,
//            let contents = collection.contents
//            else { return [] }
//        
//        let results = (contents.array as? [STContent]) ?? []
//        
//        let sorted = results.sorted(by: {
//            return $0.order < $1.order
//        })
//        return sorted
//    }
    
    func prepareVideoPlay(withContent content: STContent) {
        guard let package = content.contentPackages?.first
            else { return }
        
        //Show and hide PopuView over videoplayer view
        /* (May be needed later!)
        self.playingVideoTitleLabel.text = content.name?.uppercased()
        self.showVideoPlayerPopUp()
         */
        
        self.videoPlayerView.playbackContext = STVideoPlaybackContext(content: content, progressPercentage: 0)
    
        self.videoPlayerView.title = content.name?.uppercased()
        let d = package.duration ?? 0
        self.videoPlayerView.duration = CGFloat(d)
        
        let streamUrlString = (self.fetchedCollection?.url ?? "") + "/contents/\(content.id)/contentpackages/\(package.id)/manifest.m3u8"
        
        let playableItem = STVideoPlayableItemDetail(urlString: streamUrlString,
                                                     duration: Float(package.duration ?? 0),
                                                     packagePath: content.firstContentPackagePath ?? "")
        self.videoPlayerView.playableItemDetail = playableItem
        
        if let img = content.images?.first,
            var urlStr = img.url {
            urlStr += "?width=400&height=200&maintain_aspect=1" // TODO: make images compliant with aspect ratio

            self.videoPlayerView.coverImageView.contentMode = .center
            self.videoPlayerView.coverImageView.sdSetImage(withString: urlStr, scaleToFillWhenFinished: true, completed: { (_, _, _, _) in
                self.videoPlayerView.coverImageView.alpha = 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.videoPlayerView.coverImageView.alpha = 1
                })
            })
        }
    }
    
    func update(watchedContentProgress progressPercentage: Float?, startedTime: Date?, updatedTime: Date?, content: STContent?) {
        guard let pp = progressPercentage,
            let ctt = content else { return }
        
        if let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator {
            syncCoordinator.watchHistoryProcessor.updateOrInsertWatchedContent(progressPercentage: pp, startedTime: startedTime,
                                                                               updatedTime: updatedTime,
                                                                               content: ctt, { (finished, watchedContent) in })
        }
    }
    
    func showVideoPlayerPopUp() {
        UIView.animate(withDuration: 0.5, animations: {
            self.videoPopupViewHeightConstraint.constant = 60
            self.videoPlayerView.layoutIfNeeded()
        })
        Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(STTableViewController.hideVideoPlayerPopUp), userInfo: nil, repeats: false)
    }
    
    func hideVideoPlayerPopUp() {
        UIView.animate(withDuration: 0.5, animations: {
            self.videoPopupViewHeightConstraint.constant = 0
            self.videoPlayerView.layoutIfNeeded()
        })
    }
}

extension STTableViewController: STVideoPlayerViewDelegate {
    func played(context: STVideoPlaybackContext?) {
        self.update(watchedContentProgress: 0,
                    startedTime: Date(),
                    updatedTime: nil,
                    content: context?.content)
    }
    
    func playNext() {
        let content = self.contents.first
        
        // fade away watched ones
        self.update(watchedContentProgress: self.videoPlayerView.playbackContext?.progressPercentage,
                    startedTime: nil,
                    updatedTime: Date(),
                    content: content)
        
        self.contents.removeFirst()
        guard let nextContent = self.contents.first
            else { return }
        
        self.prepareVideoPlay(withContent: nextContent)
        self.videoPlayerView.playbackContext = STVideoPlaybackContext(content: nextContent, progressPercentage: 0)
        self.videoPlayerView.play()
        
        // remove next cell
        let row = 0
        if tableView.numberOfRows(inSection: 0) > row {
            let indexPath = IndexPath(row: row, section: 0)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData() // to update where "UP NEXT" should be
        }
    }
    
    func stopped(context: STVideoPlaybackContext?) {
        self.update(watchedContentProgress: context?.progressPercentage,
                    startedTime: nil,
                    updatedTime: Date(),
                    content: context?.content)
    }
    
    func paused(context: STVideoPlaybackContext?) {
        self.update(watchedContentProgress: context?.progressPercentage,
                    startedTime: nil,
                    updatedTime: Date(),
                    content: context?.content)
    }

    func resumed(context: STVideoPlaybackContext?) {
    }
    
    func didTapWatchMore() {
        self.cardDelegate?.request(forTabSwitch: self.videoPlayerView.playbackContext?.content?.media)
    }

    func showWifiSettingsAlert() {
        let alert = UIAlertController(title: kAppNameForAlertTitle, message: kWifiAlertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension STTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate enum TableSectionType: Int {
        case normal = 0
        case loaderCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isLoaderShown ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == TableSectionType.normal.rawValue else {
            return 1
        }
        
        guard !self.isDuringFirstTimeTableLoading else {
            return max(0, self.tempAnimationContents.count - 1)
        }
        
        tableView.setContentOffset(CGPoint(x: 0,y :25*(self.contents.count - 1)*98), animated: false)

        return max(0, (self.contents.count - 1)*50) // skip the first item
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // check to show loader
        if indexPath.section == TableSectionType.loaderCell.rawValue &&
            self.isLoaderShown
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loaderCell") as! STLoaderTableCell
            cell.activityIndicator.isHidden = true
//            cell.activityIndicator.startAnimating()
//            performSelector(onMainThread: #selector(fetchMore), with: nil, waitUntilDone: false) // add fetch to run-loop to avoid slowness on loading cells
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kSTTableV3Cell") as! STTableV3Cell
        cell.isUpNext = indexPath.row == 0
        
        let objs = self.contents
        let item = objs[(indexPath.row%(self.contents.count - 1))+1] // skip the first item
        cell.titleLabel.text = item.name?.uppercased()
        
        /*
        let collectionName = (item.collections?.array.first as? STCollection)?.name //?.replacingOccurrences(of: " ", with: "")
        let subCollectionName = collectionName?.components(separatedBy: "|").last
        cell.setGenre(title: subCollectionName?.uppercased(), genreIcon: nil)
 */
        cell.genreLabel.text = item.media?.name?.uppercased()

        cell.isLiveStream = item.isLiveStream
        let d = (item.contentPackages?.first)?.duration
        let dSeconds = Int(d ?? 0)
        cell.durationLabel.text = String(format: "%@", dSeconds.secondsToTimeString())
        
        cell.isUncensored = item.isUncensored
        
        // color
        let bgColor = (indexPath.row % 2 == 0) ? UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1) :
            UIColor(red: 19/255.0, green: 19/255.0, blue: 19/255.0, alpha: 1)
        cell.backgroundColor = bgColor
        cell.imgGradientView.colorB = bgColor

        // fade in downloaded image
        if let urlStr = item.images?.first?.url(withSize: CGSize(width: 400, height: 200)) {
            cell.imgView.sdSetImage(withString: urlStr, scaleToFillWhenFinished: true, completed: { (_, _, _, _) in
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        guard indexPath.section == TableSectionType.normal.rawValue
            else { return }
        
        let objs = self.contents
        let content = objs[(indexPath.row%(self.contents.count - 1)) + 1] // skip the first item
        guard let package = content.contentPackages?.first
            else { return }
                
        self.prepareVideoPlay(withContent: content)
        self.videoPlayerView.play(context: STVideoPlaybackContext(content: content, progressPercentage: 0))
        
        // remove selected
        self.contents.remove(at: (indexPath.row%(self.contents.count - 1)) + 1)
        
        if tableView.numberOfRows(inSection: 0) > indexPath.row {
            
            var arr1: NSMutableArray = []
            for i in (0...49).reversed() {
                let indexPathTemp = NSIndexPath(row: indexPath.row%(self.contents.count - 1)+i*(self.contents.count - 1) , section: 0)
                arr1.insert(indexPathTemp, at: 0)
               
            }

            tableView.deleteRows(at: arr1 as! [IndexPath], with: .fade)
            tableView.reloadData() // to update where "UP NEXT" should be
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.indexPathsForVisibleRows?.last?.row { // trigger when last visible cell loaded
            self.cardDelegate?.request(forLoaderToShow: false, context: nil)
        }
        
        // animate new cell when first loaded, or scrolling up
        if (_scrollDirection == .none && self.isDuringFirstTimeTableLoading) ||
            _scrollDirection == .up
        {
            // 1. set the initial state of the cell
            cell.alpha = 0
            //        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0) //slide from the left side
            //let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 200, 0) //slide from the top
            let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -200, 0) //slide from the bottom
            cell.layer.transform = transform
            
            // 2. UIView animation method to change to the final state of the cell
            UIView.animate(withDuration: 0.4, animations: {
                cell.alpha = 1.0
                cell.layer.transform = CATransform3DIdentity
            })
        }
    }
    
 }

extension STTableViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
            UIView.animate(withDuration: 0.0, animations: {
                // Determine which table cell the scrolling will stop on.
                let cellHeight: CGFloat = 98.0
                var cellIndex: NSInteger
                cellIndex = NSInteger(floor (targetContentOffset.pointee.y / cellHeight))
                
                // Round to the next cell if the scrolling will stop over halfway to the next cell.
                if ((targetContentOffset.pointee.y - (floor(targetContentOffset.pointee.y / cellHeight) * cellHeight)) > cellHeight) {
                    cellIndex += 1;
                }
                
                // Adjust stopping point to exact beginning of cell.
                targetContentOffset.pointee.y =  CGFloat(cellIndex) * cellHeight
            })
        }
    }
}



enum STScrollDirection {
    case none
    case up
    case down
}
