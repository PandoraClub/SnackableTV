//
//  STMainViewController+Menu.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-27.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

extension STMainViewController: STMenuViewControllerDelegate {
    func didSelect(menuItem: STMenuItem, atIndex index: Int, fromViewController vc: UIViewController) {
        // set drawer selected state
        guard let menuVC = vc as? STMenuViewController,
            menuItem.title != selectedMenuItem.title else
        {
            return
        }
        
        selectedMenuItem = menuItem
        menuVC.selectedMenuItem = self.selectedMenuItem
        menuVC.menuItemsTableView?.reloadData()
        
        guard menuItem.title != "Settings" else { // TODO: skip settings page etc
            vc.dismiss(animated: true, completion: {
                let settingsVC = STStoryboardFactory.miscStoryboard.instantiateViewController(withIdentifier: menuItem.storyboardID)
                self.present(settingsVC, animated: true, completion: nil)
            })
            return
        }
        guard menuItem.title != "Feedback" else {
            _ = UIApplication.shared.openURL(URL(string: "mailto:Feedback@snackabletv.com")!)
            return
        }
        
        // update top bar
        self.customNavBarView.titleLabel.text = menuItem.title.uppercased()
        self.tabsHeaderView.resetSelectedIndex() // TODO: allow change arbitrary index
        
        if menuItem.title ~= "Watch History" {
            let vc = UIStoryboard(name: "WatchHistory", bundle: nil).instantiateViewController(withIdentifier: "stWHTableVC") as! STCardViewController
            cardViewControllers = [vc]
        } else {
            if index < topCategoryItems.count {
                cardViewControllers = topCategoryItems[index].items.map {
                    $0.viewController.collectionId = $0.collectionId // TODO: temp
                    $0.viewController.title = topCategoryItems[index].name.uppercased()
                    return $0.viewController
                }
                self.tabsHeaderView.tabTitles = topCategoryItems[index].items.map { return $0.title }
            }
        }
        
        // configure for root VC
        embedNavVC!.viewControllers = [cardViewControllers.first!] // start with root
        if cardViewControllers.count > 1 { // only configureCard transtion if thera are multiple cards
            self.configureCard(forViewController: cardViewControllers.first!)
        }
        cardViewControllers.first!.cardDelegate = self // control cardVC delegate callbacks
        vc.dismiss(animated: true, completion: nil)
    }
}

extension STMainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ACBlurInAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ACBlurOutAnimator()
    }
}
