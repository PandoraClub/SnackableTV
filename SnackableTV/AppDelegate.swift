//
//  AppDelegate.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-03-29.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit
import AirshipKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appConfiguration: AppConfiguration?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // set style
        STStyle.configureAppStyle()
        
        let remoteSession = ACRemoteSession(domain: ACSettings.shared.host.domain)
        let syncCoordinator = ACSyncCoordinator(remoteSession: remoteSession)
        
        // build app configuration
        var appConfigurator: AppConfiguratorType = AppConfigurator()
        appConfigurator.remoteSession = remoteSession
        appConfigurator.syncCoordinator = syncCoordinator
        self.appConfiguration = appConfigurator.configure()
        
        return true
    }
}

let sharedAppDelegate = UIApplication.shared.delegate as! AppDelegate
