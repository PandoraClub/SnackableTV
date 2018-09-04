//
//  STWatchHistoryViewController.swift
//  SnackableTV
//
//  Created by Thomas Varghese on 2017-04-18.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import CoreData

class STWatchHistoryViewController: STCardViewController {
    
    @IBOutlet weak var headerLeftTitleLabel: UILabel!
    @IBOutlet weak var headerRightButton: ACBorderedButton!
    @IBAction func headerRightButtonTapped(_ sender: Any) {
        if let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator
        {
            do {
                try syncCoordinator.coreDataStack.mainManagedObjectContext.removeAll(managedObjectType: STWatchedContent.self)
                try self.fetchedResultsController?.performFetch()
                let watchedContents = self.fetchedResultsController?.fetchedObjects
                self.isEmpty = true
                /*
                self.headerLeftTitleLabel.text = "\(watchedContents?.count ?? 0) ITEMS"
                self.tableView.reloadData()
                 */
            } catch let e {
                print("eee:\(e)")
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var zeroStateView: STZeroStateView!
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isEmpty = true
        self.cardDelegate?.request(forHeaderCollapse: STHeaderCollapseOption.collaspeTabBar(.normal), context: nil)
        
        if let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator
        {
            self.fetchedResultsController = NSFetchedResultsController<NSManagedObject>
                .instantiate(entityName: "STWatchedContent",
                             predicate: nil,
                             managedObjectContext: syncCoordinator.coreDataStack.mainManagedObjectContext,
                             fetchOffset: 0,
                             fetchLimit: 0,
                             sortDescriptors: [],
                             delegate: self)
            do {
                try self.fetchedResultsController?.performFetch()
                let watchedContents = self.fetchedResultsController?.fetchedObjects
                
                self.headerLeftTitleLabel.text = "\(watchedContents?.count ?? 0) ITEMS"
                if (watchedContents?.count ?? 0) > 0 {
                    self.isEmpty = false
                    self.tableView.reloadData()
                }
            } catch {}
        }
    }
    
    var isEmpty: Bool = true {
        didSet {
            zeroStateView.isHidden = !isEmpty
            zeroStateView.firstLabel.text = "No items in Watch History"
            zeroStateView.secondLabel.text = "Check back later for watched contents"
            zeroStateView.submitButton.isHidden = isEmpty
            self.headerRightButton.isHidden = isEmpty
            self.tableView.isHidden = isEmpty
        }
    }
}

extension STWatchHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let watchedContents = self.fetchedResultsController?.fetchedObjects
        return watchedContents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kWatchHistoryTableCell") as! STWatchHistoryTableViewCell
        
        let watchedContents = self.fetchedResultsController?.fetchedObjects as! [STWatchedContent]
        cell.titleLabel.text = watchedContents[indexPath.row].content?.name
        
        let d = watchedContents[indexPath.row].content?.contentPackages?.first?.duration
        let dSeconds = Int(d ?? 0)
        cell.durationLabel.text = String(format: "%@", dSeconds.secondsToTimeString())
        
        cell.progressBarView.progressPercentage = watchedContents[indexPath.row].progressPercentage?.floatValue ?? 0
        cell.imgView.sdSetImage(withString: watchedContents[indexPath.row].content?.images?.first?.url(withSize: CGSize(width: 400, height: 200)), placeholderName: "imgPlaceholder")
        
        cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.black : UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1)
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        
        guard let wc = self.fetchedResultsController?.fetchedObjects?[indexPath.row] as? STWatchedContent
            else { return }
        
        // present 
        let vc = STStoryboardFactory.miscStoryboard.instantiateViewController(withIdentifier: "kFullScreenVideoVC") as! STFullScreenVideoViewController
        _ = vc.view
        vc.videoPlayerView.duration = CGFloat(wc.content?.contentPackages?.first?.duration ?? 0)
        
        let playableItem = STVideoPlayableItemDetail(urlString: wc.content?.streamUrlString ?? "",
                                                     duration: Float(wc.content?.contentPackages?.first?.duration ?? 0),
                                                     packagePath: wc.content?.firstContentPackagePath ?? "")
        vc.videoPlayerView.playableItemDetail = playableItem
        
        vc.videoPlayerView.playbackContext = STVideoPlaybackContext(content: wc.content,
                                                                    progressPercentage: wc.progressPercentage?.floatValue)
        UIApplication.shared.topViewController()?.present(vc, animated: true, completion: nil)
    }
}

extension STWatchHistoryViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}
