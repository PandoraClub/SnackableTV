//
//  debug_SettingsTableViewController.swift
//  <?>App
//
//  Created by Austin Chen on 2017-01-26.
//  Copyright © 2017 10.1. All rights reserved.
//

import UIKit
import Crashlytics

class debug_SettingsTableViewController: UITableViewController {
    
    @IBAction func leftBarButtonTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearQuitButtonTapped(_ sender: Any) {
        if let coreDataStack = (sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator)?.coreDataStack {
            coreDataStack.destroyPersistentStore()
        } else {
            log(message: "not cleared")
        }
        abort()
    }
    
    @IBOutlet weak var serverEnvCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serverEnvCell.detailTextLabel?.text = ACSettings.shared.host.name
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.section {
        case 0:
            self.performSegue(withIdentifier: "pushFromDebugSettingsVCToEnvVC", sender: nil)
            break
        case 1:
            // Crashlytics.sharedInstance().crash()
            Crashlytics.sharedInstance().throwException()
            break
        default:
            break
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
