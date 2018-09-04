//
//  STRootViewController.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-05-09.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import CoreData

class STRootViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    
    var mainVC: STMainViewController?
    var isFirstLoaded = true
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
    fileprivate var topCategoryItems: [STTopCategoryItem] = []
    
    /*
      1. if were to show the splash, splash finish after data being loaded
      2. if no splash, show the main after data loaded
     */
    fileprivate let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let syncCoordinator = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator
            else { return }
        
        syncCoordinator.syncAll { (_, _, _) in }
        
        self.dispatchGroup.enter() // enter 2
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: ACSyncAllCompletedNotification), object: nil, queue: nil) { (note) in
            guard self.topCategoryItems.count == 0 // ignore if topCategoryItems is set up already, for now
                else { return }
            
            guard let synced = note.userInfo?["kSynced"] as? [STJsonCollection]
                else { return }
            
            let topLevelCollectionIds = synced.filter {
                    $0.itemsType ~= "Collection"
                }.map {
                    $0.id
                }
            
            self.fetchedResultsController = NSFetchedResultsController<NSManagedObject>
                .instantiate(entityName: "STCollection",
                             predicate: NSPredicate(format: "id IN %@",  topLevelCollectionIds),
                             managedObjectContext: syncCoordinator.coreDataStack.mainManagedObjectContext,
                             fetchOffset: 0,
                             fetchLimit: 0,
                             sortDescriptors: [],
                             delegate: nil)
            do {
                try self.fetchedResultsController?.performFetch()
                
                if let topCollections = self.fetchedResultsController?.fetchedObjects as? [STCollection] {
                    
                    topCollections.forEach { topCollection in
                        var subCatItems: [STCategoryItem] = []
                        
                        guard var subCollections = topCollection.childCollections?.array as? [STCollection]
                            else { return }
                        subCollections.sort(by: { // sort by order
                            $0.order < $1.order
                        })
                        
                        var topCollectionName = ""
                        if let collectionName = topCollection.name?.replacingOccurrences(of: " ", with: "") {
                            if collectionName.contains("Series") {
                                topCollectionName = "Series"
                            } else if collectionName.contains("Content") {
                                topCollectionName = "Feed"
                            }
                        }
                        
                        subCollections.forEach { subCollection in
                            let collectionName = subCollection.name?.replacingOccurrences(of: " ", with: "")
                            let subCollectionName = collectionName?.components(separatedBy: "|").last
                            
                            var viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "stTableVC") as! STCardViewController
                            if topCollectionName ~= "Series" {
                                viewController = UIStoryboard(name: "Series", bundle: nil).instantiateViewController(withIdentifier: "stSeriesVC") as! STCardViewController
                            }
                            let subCatItem = STCategoryItem(title: subCollectionName ?? "",
                                                            viewController: viewController,
                                                            collectionId: subCollection.id)
                            subCatItems.append(subCatItem)
                        }
                        
                        let topCatItem: STTopCategoryItem = (name: topCollectionName, items: subCatItems)
                        self.topCategoryItems.append(topCatItem)
                    }
                    self.topCategoryItems.sort { $0.name < $1.name } // place FEED before SERIES 
                    
                    self.dispatchGroup.leave() // leave 2
                }
            } catch let e {
            }
        }
        
        self.dispatchGroup.enter() // enter 1
        
        // when both 1 & 2 finish
        self.dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            self.mainVC = STStoryboardFactory.mainStoryboard.instantiateViewController(withIdentifier: "mainContainerVC") as? STMainViewController
            self.mainVC?.topCategoryItems = self.topCategoryItems
            
            if let categoryItems = self.topCategoryItems.first?.items {
                self.mainVC?.cardViewControllers = categoryItems.map {
                    $0.viewController.collectionId = $0.collectionId // TODO: temp
                    $0.viewController.title = self.topCategoryItems.first?.name.uppercased()
                    return $0.viewController
                }
            }
            
            self.present(self.mainVC!, animated: false, completion: nil)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard isFirstLoaded else
        {
            dispatchGroup.leave() // leave 1
            return
        }
        isFirstLoaded = false
        
        if STKeyStore.isAppFirstLaunch {
            _ = self.performSegue(withIdentifier: "presentFromRootVCToSplashVC", sender: nil)
            STKeyStore.keyStoreItem = STKeyStoreItem(appInstalled: true)
        } else {
            dispatchGroup.leave() // leave 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentFromRootVCToSplashVC" {
            (segue.destination as? STSplashViewController)?.delegate = self
        } else if segue.identifier == "presentFromRootVCToMainVC" {
        }
    }
}

extension STRootViewController: STSplashViewControllerDelegate {
    
    func didStart(splash viewController: UIViewController) {
        self.logoImageView.isHidden = true // avoid seeing the snackableLogo image
    }
    
    func shouldComplete(splash viewController: UIViewController) {
        dispatchGroup.leave() // leave 1
    }
    
    func didFinish(splash viewController: UIViewController) {
        if let vc = mainVC {
            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
        }
        viewController.dismiss(animated: false, completion: nil)
    }
}
