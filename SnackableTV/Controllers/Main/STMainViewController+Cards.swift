//
//  STMainViewController+Cards.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-27.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

extension STMainViewController {
    
    func collaspeHeader(option: STHeaderCollapseOption, animated: Bool, completion: ((Bool) -> ())? = nil) {
        guard option.order != currentCollapseOption.order
            else { return } // ignore redundant state
        
        self.currentCollapseOption = option
        
        switch option {
        case .none:
            self.customNavBarViewTop.constant = 0
            self.tabsHeaderViewTop.constant = 54
        case .collaspeTabBar(let tabCollapseOption):
            self.customNavBarViewTop.constant = 0
            
            switch tabCollapseOption {
            case .normal:
                self.tabsHeaderViewTop.constant = 14
            case .full:
                self.tabsHeaderViewTop.constant = self.tabsHeaderView.bounds.height * -1
            }
        case .collaspeAll:
            self.customNavBarViewTop.constant = self.customNavBarView.bounds.height * -1
            self.tabsHeaderViewTop.constant = self.tabsHeaderView.bounds.height * -1
        }
        
        guard animated else {
            self.tabsHeaderView.superview?.layoutIfNeeded()
            if let c = completion { c(true) }
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tabsHeaderView.superview?.layoutIfNeeded()
        }, completion: { (finished) in
            self.tabsHeaderView.superview?.layoutIfNeeded()
            if let c = completion { c(finished) }
        })
    }
}

extension STMainViewController: STCardViewControllerDelegate {
    weak var tempCustomNavBarView: STCustomNavBarView? {
        return self.customNavBarView
    }
    
    func request(forHeaderCollapse option: STHeaderCollapseOption, context: STCategoryItem?) {
        self.collaspeHeader(option: option, animated: true)
    }
    
    func request(forLoaderToShow: Bool, context: STCategoryItem?) {
        if forLoaderToShow {
            self.showLoading()
        } else {
            self.hideLoading()
        }
    }
    
    func request(forTabSwitch: Any?) {
        guard let media = forTabSwitch as? STMedia
            else { return } // ignore if not link to a media
        
        /* go to series
         */
        let index = 1 // 0 for FEED, 1 for SERIES
        if index < topCategoryItems.count {
            cardViewControllers = topCategoryItems[index].items.map {
                $0.viewController.collectionId = $0.collectionId // TODO: temp
                $0.viewController.title = topCategoryItems[index].name.uppercased()
                return $0.viewController
            }
            self.tabsHeaderView.tabTitles = topCategoryItems[index].items.map { return $0.title }
        }
        
        // configure for root VC
        embedNavVC!.viewControllers = [cardViewControllers.first!] // start with root
        if cardViewControllers.count > 1 { // only configureCard transtion if thera are multiple cards
            self.configureCard(forViewController: cardViewControllers.first!)
        }
        cardViewControllers.first!.cardDelegate = self // control cardVC delegate callbacks
        
        /* change selected Menu item to Series
         */
        
        /* go to the Series home page
         */
        let storyboard = UIStoryboard(name: "Series", bundle: nil)
        let watchSeriesVC = storyboard.instantiateViewController(withIdentifier: "stWatchSeriesVC") as! STSeriesTableViewController
        watchSeriesVC.customNavBarItem = STCustomNavBarItem(backgroundColor: UIColor(white: 0, alpha: 0.8),
                                                            title: media.name?.uppercased(),
                                                            isBackButtonHidden: false, isRightBarButtonHidden: true)
        watchSeriesVC.media = media
        embedNavVC?.pushViewController(watchSeriesVC, animated: true)
        
        self.collaspeHeader(option: STHeaderCollapseOption.collaspeTabBar(.normal), animated: false)
    }
}
