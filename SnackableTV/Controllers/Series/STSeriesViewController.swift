//
//  STSeriesViewController.swift
//  SnackableTV
//
//  Created by Thomas Varghese on 2017-04-26.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import CoreData

fileprivate let kTableCellHeight = 210.0 as CGFloat

class STSeriesViewController: STCardViewController {
    
    @IBOutlet weak var seriesTableView: UITableView!
    fileprivate var fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
    fileprivate var _scrollDirection: STScrollDirection = .none
    fileprivate var _lastContentOffset: CGFloat = 0
    var tempAnimationMedias: [STMedia] = []
    var isDuringFirstTimeTableLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* // The below commented code is moved to ViewDidAppear() to implement animation
        if let collectionId = self.collectionId,
            let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator
        {
            syncCoordinator.syncAll({ (success, synced, error) in
                if let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator
                {
                    self.fetchedResultsController = NSFetchedResultsController<NSManagedObject>.instantiate(entityName: "STCollection",
                                                                                                            predicate: NSPredicate(format: "id == \(collectionId)"),
                                                                                                            managedObjectContext: syncCoordinator.coreDataStack.mainManagedObjectContext,
                                                                                                            fetchOffset: 0,
                                                                                                            fetchLimit: 0,
                                                                                                            sortDescriptors: [],
                                                                                                            delegate: nil)
                    do {
                        try self.fetchedResultsController?.performFetch()
                        
                        let masterCollections = (self.fetchedResultsController?.fetchedObjects as? [STCollection]) ?? []
                        guard masterCollections.first != nil else { return }
                        
                        /*
                            let masterCollection = masterCollections.first
                            let seriesId = masterCollection?.id
                            let seriesType = masterCollection?.itemsType
                            let item = masterCollection?.medias?.firstObject as? STMedia
                            let text = item?.name
                         */
                        self.seriesTableView.reloadSections([0], with: .fade)
                    } catch {}
                }
            })
        }*/

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard self.fetchedMedias.count == 0 // ignore if not first time loading
            else { return }
        
        if let collectionId = self.collectionId,
            let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator
        {
            syncCoordinator.syncAll({ (success, synced, error) in
                if let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator
                {
                    self.fetchedResultsController = NSFetchedResultsController<NSManagedObject>.instantiate(entityName: "STCollection",
                                                                                                            predicate: NSPredicate(format: "id == \(collectionId)"),
                                                                                                            managedObjectContext: syncCoordinator.coreDataStack.mainManagedObjectContext,
                                                                                                            fetchOffset: 0,
                                                                                                            fetchLimit: 0,
                                                                                                            sortDescriptors: [],
                                                                                                            delegate: nil)
                    do {
                        try self.fetchedResultsController?.performFetch()
                        
                        let masterCollections = (self.fetchedResultsController?.fetchedObjects as? [STCollection]) ?? []
                        guard masterCollections.first != nil else { return }
                        
                        if self.fetchedMedias.count > 1 { // only reload table if there are cells
                            
                            var tDelay: Double = 0
                            let n = min(8, self.fetchedMedias.count) // animate only 8 rows
                            for (idx, c) in self.fetchedMedias.enumerated() {
                                guard idx > 0 else {
                                    self.tempAnimationMedias.append(c)
                                    continue
                                }
                                guard idx < n
                                    else { return }
                                
                                self.isDuringFirstTimeTableLoading = true
                                
                                delay(tDelay, closure: {
                                    self.seriesTableView.beginUpdates()
                                    self.tempAnimationMedias.append(c)
                                    self.seriesTableView.insertRows(at: [IndexPath(row: idx-1, section: 0)], with: .none)
                                    self.seriesTableView.endUpdates()
                                    
                                    if idx == n - 1 {
                                        self.isDuringFirstTimeTableLoading = false
                                        self.tempAnimationMedias = []
                                        self.seriesTableView.reloadData() // let table view know the real count, otherwise crash
                                    }
                                })
                                tDelay += 0.09
                                
                            }
                        }
                        
                        /*
                         let masterCollection = masterCollections.first
                         let seriesId = masterCollection?.id
                         let seriesType = masterCollection?.itemsType
                         let item = masterCollection?.medias?.firstObject as? STMedia
                         let text = item?.name
                         */
                        //self.seriesTableView.reloadSections([0], with: .fade)
                    } catch {}
                }
            })
        }

        
    }
    
    var fetchedMedias: [STMedia] {
        let objs = (self.fetchedResultsController?.fetchedObjects as? [STCollection]) ?? []
        
        guard let collection = objs.first,
            let medias = collection.medias
            else { return [] }
        
        let results = (medias.array as? [STMedia]) ?? []
        let sorted = results.sorted(by: {
            return ($0.name ?? "") < ($1.name ?? "")
        })
        
        return sorted
    }
}

extension STSeriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard !self.isDuringFirstTimeTableLoading else {
            return max(0, self.tempAnimationMedias.count - 1)
        }
        
        return self.fetchedMedias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kSeriesTableCell") as! STSeriesTableCell
        
        let item = fetchedMedias[indexPath.row]
        
        cell.titleLabel.text  = item.name?.uppercased()
        let snackCount : Int? = item.contents?.count// this code should be changed to get the actual media count
        cell.subtitleLabel.text = "\(snackCount!) SNACKS"
        
        let posterUrlStr = item.images?.filter{ $0.type ~= "poster" }.first?.url(withSize: CGSize(width: 100, height: 160))
        cell.imgView.sdSetImage(withString: posterUrlStr, scaleToFillWhenFinished: true)
        
        let keyartUrlStr = item.images?.filter{ $0.type ~= "thumbnail" }.first?.url(withSize: CGSize(width: 500, height: 210))
        cell.backgroundImgView.sdSetImage(withString: keyartUrlStr, scaleToFillWhenFinished: true)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        let item = fetchedMedias[indexPath.row]

        //
        let storyboard = UIStoryboard(name: "Series", bundle: nil)
        let watchSeriesVC = storyboard.instantiateViewController(withIdentifier: "stWatchSeriesVC") as! STSeriesTableViewController
        watchSeriesVC.customNavBarItem = STCustomNavBarItem(backgroundColor: UIColor(white: 0, alpha: 0.8),
                                                 title: item.name?.uppercased(),
                                                 isBackButtonHidden: false, isRightBarButtonHidden: true)
        watchSeriesVC.media = item
        navigationController?.pushViewController(watchSeriesVC, animated: true)

        self.cardDelegate?.request(forHeaderCollapse: STHeaderCollapseOption.collaspeTabBar(.normal), context: nil)
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
            UIView.animate(withDuration: 0.4, animations: {
                cell.alpha = 1.0
                cell.layer.transform = CATransform3DIdentity
            })
        }
    }
}

extension STSeriesViewController: UIScrollViewDelegate {
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
