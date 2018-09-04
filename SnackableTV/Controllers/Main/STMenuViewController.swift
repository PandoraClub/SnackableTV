//
//  STMenuViewController.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-12.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

protocol STMenuViewControllerDelegate: class {
    func didSelect(menuItem: STMenuItem, atIndex index: Int, fromViewController vc: UIViewController)
}

struct STMenuItem {
    let normalImageName: String
    let selectedImageName: String
    let title: String
    let storyboardFileName: String
    let storyboardID: String
}

class STMenuViewController: UIViewController {

    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var noEffectContainerView: UIView!
    
    @IBOutlet weak var menuItemsTableView: UITableView!
    
    static let menuItems: [STMenuItem] = [
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
                   title: "Settings",
                   storyboardFileName: "Misc",
                   storyboardID: "stSettingsNavVC"),
        
        STMenuItem(normalImageName: "",
                   selectedImageName: "",
                   title: "Feedback",
                   storyboardFileName: "na",
                   storyboardID: "na")
    ]
    
    var selectedMenuItem: STMenuItem?
    weak var delegate: STMenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.menuItemsTableView.reloadData()
    }
}

extension STMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ACSettings.shared.isDebugEnabled() {
            return type(of: self).menuItems.count + 1
        }
        return type(of: self).menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTableCell") as! STMenuTableViewCell
        // debug
        if ACSettings.shared.isDebugEnabled(),
            indexPath.row == type(of: self).menuItems.count
        {
            cell.mainTitleLabel.text = "(Debug) Settings"
            return cell
        }
        
        let item = type(of: self).menuItems[indexPath.row]
        if item.title == selectedMenuItem?.title {
            cell.mainTitleLabel?.font = UIFont.montserratFont(ofSize: 24, weight: UIFontWeightRegular)
        } else {
            cell.mainTitleLabel?.font = UIFont.montserratFont(ofSize: 22, weight: UIFontWeightLight)
        }
        cell.mainTitleLabel.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ACSettings.shared.isDebugEnabled(),
            indexPath.row == type(of: self).menuItems.count
        {
            let vc = STStoryboardFactory.debugStoryboard.instantiateViewController(withIdentifier: "debugSettingsNavVC")
            self.present(vc, animated: true, completion: nil)
            return
        }
        
        let item = type(of: self).menuItems[indexPath.row]
        self.delegate?.didSelect(menuItem: item, atIndex: indexPath.row, fromViewController: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
