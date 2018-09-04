//
//  STSettingsViewController.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-05-01.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class STSettingsViewController: UIViewController {

    @IBOutlet weak var customNavBarView: STCustomNavBarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.customNavBarView.titleLabel.text = "Settings".uppercased()
        self.customNavBarView.backgroundBlurView.contentView.backgroundColor = UIColor.clear
        self.customNavBarView.backgroundBlurView.effect = UIBlurEffect(style: .dark)
        
        self.customNavBarView.rightBarButton.setImage(nil, for: .normal)
        self.customNavBarView.rightBarButton.setTitle("Done", for: .normal)
        // text color set in xib
        
        self.customNavBarView.rightBarButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        
        appVersionLabel.text = "© 2016 BellMedia. SnackableTV App " + AppConfiguration.versionWithBuild()
    }
    
    func rightBarButtonTapped(_ target: Any?) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}

extension STSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "General".uppercased()
        } else {
            return "About".uppercased()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableCell: UITableViewCell? = nil
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "kSettingsNoteCell") as! STSettingNoteTableCell
            cell.delegate = self
            if indexPath.row == 0 {
                cell.titleLabel.text = "WiFi Only for Video"
                cell.tag = indexPath.row
                if STSettings.isVideoOnWifiOnlyEnabled() {
                    cell.rightSwitch.setOn(true, animated: false)
                }
                else {
                    cell.rightSwitch.setOn(false, animated: false)
                }
            } else if indexPath.row == 1 {
                cell.titleLabel.text = "Push Notification"
                cell.tag = indexPath.row
                let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
                if notificationType == [] {
                    cell.rightSwitch.setOn(false, animated: false)
                    print("notifications are NOT enabled")
                } else {
                    cell.rightSwitch.setOn(true, animated: false)
                    print("notifications are enabled")
                }
            }
            tableCell = cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "kSettingsLinkCell") as UITableViewCell!
            if indexPath.row == 0 {
                cell?.textLabel?.text = "FAQ"
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = "Terms & Conditions"
            } else if indexPath.row == 2 {
                cell?.textLabel?.text = "Privacy Policy"
            }
            tableCell = cell
        }
        return tableCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
        } else {
            if indexPath.row == 0 {
                // not do anything
            } else if indexPath.row == 1 {
                self.performSegue(withIdentifier: "pushFromSettingsVCToTCVC", sender: nil)
            } else if indexPath.row == 2 {
                _ = UIApplication.shared.openURL(URL(string: "http://support.bell.ca/Billing-and-Accounts/Security_and_privacy/How_does_Bell_respect_my_privacy")!)
            }
        }
    }
}

extension STSettingsViewController: STSettingNoteTableCellDelegate {
    func didTapOnOffSwitch(atIndex index: Int, mode: Bool)
    {
        switch index {
        case 0: //Wifi
            STSettings.enableVideoOnWifiOnly(withMode: mode)
        case 1: //Push
            let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)! as URL
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(settingsUrl)
            }
            
            break
        default:
            break
        }
    }
}
