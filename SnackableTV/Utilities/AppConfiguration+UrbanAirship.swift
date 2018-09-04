//
//  AppConfiguration+UrbanAirship.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-05-08.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import AirshipKit
import UIKit

extension AppConfigurator {
    
    func configureUA(byAchiveType appAchiveType: STAppArchiveType) {
        // third parties
        // Urban Airship Integration
        var uaConfig: UAConfig?
        
        switch appAchiveType {
        case .inHouse:
            uaConfig = UAConfig.default()
        case .bellMedia:
            if let path = Bundle.main.path(forResource: "AirshipConfigBellMedia", ofType: "plist") {
                uaConfig = UAConfig(contentsOfFile: path)
            }
        }
        
        guard let config = uaConfig,
            config.validate() else
        {
            showInvalidUAConfigAlert()
            return
        }
        
        config.messageCenterStyleConfig = "UAMessageCenterDefaultStyle"
        
        // It will be set to the value in the loaded config upon takeOff
        UAirship.setLogLevel(UALogLevel.trace)
        
        // Call takeOff (which creates the UAirship singleton)
        UAirship.takeOff(config)
        
        // Print out the application configuration for debugging (optional)
        print("Config:\n \(config)")
        
        // Set the icon badge to zero on startup (optional)
        UAirship.push()?.resetBadge()
        UAirship.push().defaultPresentationOptions = [.alert, .badge, .sound]
    }
    
    func showInvalidUAConfigAlert() {
        let alertController = UIAlertController.init(title: "Invalid AirshipConfig.plist", message: "The AirshipConfig.plist must be a part of the app bundle and include a valid appkey and secret for the selected production level.", preferredStyle:.actionSheet)
        alertController.addAction(UIAlertAction.init(title: "Exit Application", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            exit(1)
        }))
        
        DispatchQueue.main.async {
            alertController.popoverPresentationController?.sourceView = sharedAppDelegate.window?.rootViewController?.view
            sharedAppDelegate.window?.rootViewController?.present(alertController, animated:true, completion: nil)
        }
    }
}
