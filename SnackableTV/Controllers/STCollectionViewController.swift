//
//  STCollectionViewController.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-03-31.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import RZTransitions
import CoreData

class STCollectionViewController: STCardViewController {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var pushPopInteractionController: RZTransitionInteractionController?
    fileprivate var fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
    var itemsBySections: [ [Any] ] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainCollectionView.delegate = self
        
        if let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator {
            syncCoordinator.syncAll({ (success, synced, error) in
                if let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator
                {
                    self.fetchedResultsController = NSFetchedResultsController<NSManagedObject>.instantiate(entityName: "STContent",
                                                                                                            predicate: nil,
                                                                                                            managedObjectContext: syncCoordinator.coreDataStack.mainManagedObjectContext,
                                                                                                            fetchOffset: 0,
                                                                                                            fetchLimit: 0,
                                                                                                            sortDescriptors: [],
                                                                                                            delegate: nil)
                    do {
                        try self.fetchedResultsController?.performFetch()
                        _ = (self.fetchedResultsController?.fetchedObjects as? [STContent]) ?? []
                        self.mainCollectionView.reloadData()
                    } catch {}
                }
            })
        }
        
        mainCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "kMainCollectionCell")
        
        itemsBySections = [
            [1,1],
            [1],
            [1,1,1],
            [1,1],
            [1],
            [1,1,1],
        ]
    }
}

extension STCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemsBySections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsBySections[section].count
//        let o = (self.fetchedResultsController?.fetchedObjects as? [STContent]) ?? []
//        return o.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kFeedCollectionCell", for: indexPath) as! STFeedCollectionCell
//        let aa = (self.fetchedResultsController?.fetchedObjects as? [STContent]) ?? []
//        let item = aa[indexPath.row]
//        if let img = item.images?.first,
//            var urlStr = img.url {
//            urlStr += "?width=400&height=200&maintain_aspect=1"
//            cell.feedImageView.sd_setImage(with: URL(string: urlStr), placeholderImage: nil)
//        }
        cell.backgroundColor = UIColor.yellow
        return cell
    }
    
}

extension STCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellCountPerRow = itemsBySections[indexPath.section].count
        
        if cellCountPerRow == 1 {
            let width = self.cellWidth(byCellCountPerRow: 1)
            let height = width.stSmallerValue(byAspectRatio: .sixteenByNine)
            return CGSize(width: width, height: height)
        } else {
            let width = self.cellWidth(byCellCountPerRow: cellCountPerRow)
            let height = width.stLargerValue(byAspectRatio: .threeByTwo)
            return CGSize(width: width, height: height)
        }
    }
}

extension STCollectionViewController {
    func cellWidth(byCellCountPerRow count: Int) -> CGFloat {
        let totalSpacing = kCollectionViewSectionMarginleft * 2 + CGFloat(count - 1) * kCollectionViewSectionCellMinSpacing
        let width = (self.view.bounds.size.width - totalSpacing) / CGFloat(count)
        return width
    }
}

fileprivate let kCollectionViewSectionMarginleft: CGFloat = 10.0 // required
fileprivate let kCollectionViewSectionCellMinSpacing: CGFloat = 9.0 // empirical

extension STCollectionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > 0 {
            self.cardDelegate?.request(forHeaderCollapse: STHeaderCollapseOption.collaspeTabBar(.full), context: nil)
        } else {
            self.cardDelegate?.request(forHeaderCollapse: .none, context: nil)
        }
    }
}
