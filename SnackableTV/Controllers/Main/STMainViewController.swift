//
//  STMainViewController.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-06.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import RZTransitions
import CoreData
import Floaty
import AirshipKit

class STMainViewController: UIViewController {
    
    @IBOutlet weak var customNavBarView: STCustomNavBarView!
    
    @IBOutlet weak var tabsHeaderView: STTabsHeaderView!
    @IBOutlet weak var loadingPlaceholderView: UIView!
    
    @IBOutlet weak var customNavBarViewTop: NSLayoutConstraint!
    @IBOutlet weak var tabsHeaderViewTop: NSLayoutConstraint!
    
    var embedNavVC: RZTransitionsNavigationController?
    
    var currentCollapseOption: STHeaderCollapseOption = .none
    
    // cards state
    var cardInteraction = STCardInteraction(inProgress: false, direction: .scrollLeft)
    
    // cards vars
    var cardViewControllers: [STCardViewController] = []
    var currentCardIdx = 0 // can NOT be replaced by STCardsHeaderView.currentIdx
    
    // menu page
    var selectedMenuItem: STMenuItem = STMenuViewController.menuItems.first!
    
//    let fab = KCFABManager.defaultInstance().getButton()

    var topCategoryItems: [STTopCategoryItem] = []
    
    fileprivate var _autoDismissTimer: Timer? // count down to show UA airship
    
    // MARK: life cycles
    
    required init?(coder aDecoder: NSCoder) { // this method is invoked before application:didFinishLaunchingWithOptions
        super.init(coder: aDecoder)
        
        RZTransitionsManager.shared().navDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavBarView.delegate = self
//        customNavBarView.rightBarButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        tabsHeaderView.delegate = self
        self.showLoading()
        
        self.customNavBarView.titleLabel.text = self.topCategoryItems.first?.name.uppercased()
        self.tabsHeaderView.tabTitles = self.topCategoryItems.first!.items.map { $0.title }
        
        // hide menu buttom when landscape
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIDeviceOrientationDidChange, object: nil, queue: nil) { (note) in
            if UIDevice.current.orientation.isPortrait {
                FloatyManager.defaultInstance().show()
            } else if UIDevice.current.orientation.isLandscape {
                FloatyManager.defaultInstance().hide()
            } else {}
        }
        
        self.layoutFAB()
        
        // count down to show UA airship
        startAutoDismissTimer(withTimeout: 5.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedVCSegue" { // called before viewDidLoad
            embedNavVC = segue.destination as? RZTransitionsNavigationController
            embedNavVC!.viewControllers = [cardViewControllers.first!] // start with root
            
            // configure for root VC
            self.configureCard(forViewController: cardViewControllers.first!)
        } else if segue.identifier == "presentFromMainVCToMenuVC" {
            if let vc = segue.destination as? STMenuViewController {
                vc.delegate = self
                vc.selectedMenuItem = selectedMenuItem
                
                // presentation
                vc.transitioningDelegate = self
                vc.modalPresentationStyle = .overCurrentContext
                vc.providesPresentationContextTransitionStyle = true
                vc.definesPresentationContext = true
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    func rightBarButtonTapped(_ target: Any?) {
        self.performSegue(withIdentifier: "presentFromMainVCToMenuVC", sender: nil)
    }
}

extension STMainViewController: STCustomNavBarViewDelegate {
    func backButtonTapped() {
        self.embedNavVC?.popViewController(animated: true)
    }
    
    func leftButtonTapped() {}
    
    func rightButtonTapped() {}
}

extension STMainViewController {
    func showLoading() {
        UIView.animate(withDuration: 0.4, animations: {
            self.loadingPlaceholderView.alpha = 1.0
        }, completion: { finished in
            self.loadingPlaceholderView.alpha = 1.0
            self.loadingPlaceholderView.isHidden = false
        })
    }
    
    func hideLoading() {
        UIView.animate(withDuration: 0.4, animations: {
            self.loadingPlaceholderView.alpha = 0.0
        }, completion: { finished in
            self.loadingPlaceholderView.alpha = 0.0
            self.loadingPlaceholderView.isHidden = true
        })
    }
}

extension STMainViewController {
    func startAutoDismissTimer(withTimeout seconds: Double) {
        if _autoDismissTimer != nil {
            self.endAutoDismissTimer()
        }
        
        _autoDismissTimer = Timer(timeInterval: seconds, target: self, selector: #selector(autoDimissTimerTriggered), userInfo: nil, repeats: false)
        RunLoop.current.add(_autoDismissTimer!, forMode: RunLoopMode.commonModes)
    }
    
    func endAutoDismissTimer() {
        _autoDismissTimer?.invalidate()
        _autoDismissTimer = nil
    }
    
    func autoDimissTimerTriggered() {
        UAirship.push().userPushNotificationsEnabled = true
        self.endAutoDismissTimer()
    }
}
