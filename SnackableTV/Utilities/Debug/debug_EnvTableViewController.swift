//
//  debug_EnvTableViewController.swift
//  <?>App
//
//  Created by Austin Chen on 2017-01-26.
//  Copyright © 2017 10.1. All rights reserved.
//

import UIKit

class debug_EnvTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            ACSettings.shared.host = ACHost.hosts[0]
            break
        case 1:
            ACSettings.shared.host = ACHost.hosts[1]
            break
        default:
            break
        }
        _ = self.navigationController?.popViewController(animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
