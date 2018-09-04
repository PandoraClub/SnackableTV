//
//  STMainViewController+Floaty.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-05-13.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import Floaty

extension STMainViewController: FloatyDelegate {
    
    func layoutFAB() {
        let floaty = FloatyManager.defaultInstance()
        
        let fab = FloatyManager.defaultInstance().button
        fab.openAnimationType = .none
        
        // item
        fab.itemSize = 30.0
        fab.itemShadowColor = UIColor.clear
        fab.titleFontNormal = UIFont.montserratFont(ofSize: 18, weight: UIFontWeightRegular)
        fab.titleFontSelected = UIFont.montserratFont(ofSize: 18, weight: UIFontWeightSemibold)
        
        // bg
        fab.solidCircleRadius = 25.0
        fab.solidCircleColor = UIColor(red: 0, green: 137/255.0, blue: 255/255.0, alpha: 1)
        fab.overlayColor = UIColor.black.withAlphaComponent(0.1)
        
        // button
        fab.buttonColor = UIColor(red: 0, green: 137/255.0, blue: 255/255.0, alpha: 1)
        fab.buttonImage = UIImage(named: "snackableLogo")
        fab.buttonShadowColor = UIColor.clear
        
        fab.cogButton.setImage(UIImage(named:"settingsCog"), for: .normal)
        fab.cogButtonSlideDistance = 100.0
        fab.cogButton.addTarget(self, action: #selector(cogButtonTapped), for: .touchUpInside)
        
        for (idx, item) in sharedMenuItems.reversed().enumerated() {
            fab.addItem(title: item.title) { fabItem in
                guard idx != fab.selectedItemIdx
                    else { return }
                fab.selectedItemIdx = idx
                
                let index = (sharedMenuItems.count - 1) - idx
                self.select(menuItem: item, atIndex: index, fromViewController: self)
            }
        }
        fab.selectedItemIdx = 3 // 3 for feed
        
        fab.fabDelegate = self
        fab.sticky = true
        
        floaty.show()
    }

    func select(menuItem: STMenuItem, atIndex index: Int, fromViewController vc: UIViewController) {
        // set drawer selected state
        guard menuItem.title != selectedMenuItem.title else
        {
            return
        }
        
        selectedMenuItem = menuItem
        
        guard menuItem.title != "Settings" else { // TODO: skip settings page etc
            let settingsVC = STStoryboardFactory.miscStoryboard.instantiateViewController(withIdentifier: menuItem.storyboardID)
            self.present(settingsVC, animated: true, completion: nil)
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
            let watchVC = UIStoryboard(name: "WatchHistory", bundle: nil).instantiateViewController(withIdentifier: "stWHTableVC") as! STCardViewController
            cardViewControllers = [watchVC]
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
    }
    
    func cogButtonTapped() {
        let settingsMenu = STMenuItem(normalImageName: "",
                               selectedImageName: "",
                               title: "Settings",
                               storyboardFileName: "Misc",
                               storyboardID: "stSettingsNavVC")
        self.select(menuItem: settingsMenu, atIndex: -1, fromViewController: self)
    }
    
    // MARK: - Floaty Delegate Methods
    func floatyOpened(_ floaty: Floaty) {
        let fab = FloatyManager.defaultInstance().button
        fab.buttonImage = UIImage(named: "menuClose")
    }
    
    func floatyClosed(_ floaty: Floaty) {
        let fab = FloatyManager.defaultInstance().button
        fab.buttonImage = UIImage(named: "snackableLogo")
        
        floaty.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        floaty.alpha = 0
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: UIViewAnimationOptions(),
                       animations: {
                        floaty.transform = .identity
                        floaty.alpha = 1
        },
                       completion: nil)
    }
 
}

fileprivate let sharedMenuItems: [STMenuItem] = [
    STMenuItem(normalImageName: "",
               selectedImageName: "",
               title: "Feed",
               storyboardFileName: "Main",
               storyboardID: "stTableVC"),
    
    STMenuItem(normalImageName: "",
               selectedImageName: "",
               title: "Series",
               storyboardFileName: "Main",
               storyboardID: "stTableVC"),
    
    STMenuItem(normalImageName: "",
               selectedImageName: "",
               title: "Watch History",
               storyboardFileName: "WatchHistory",
               storyboardID: "stWHTableVC"),
    
    STMenuItem(normalImageName: "",
               selectedImageName: "",
               title: "Feedback",
               storyboardFileName: "na",
               storyboardID: "na")
]
