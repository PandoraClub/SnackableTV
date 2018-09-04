//
//  AppConfigurator.swift
//  PostSurgicalMonitoring
//
//  Created by Austin Chen on 2016-06-01.
//  Copyright © 2016 Hubub Health. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics
import HockeySDK
import AirshipKit

enum STAppArchiveType {
    case inHouse
    case bellMedia
}

protocol AppConfiguratorType {
    var remoteSession: ACRemoteSession? {get set}
    var syncCoordinator: ACSyncCoordinator? {get set}
    func configure() -> AppConfiguration?
}

struct AppConfigurator: AppConfiguratorType {
    // builder properties
    var remoteSession: ACRemoteSession?
    var syncCoordinator: ACSyncCoordinator?
    static let measurement = ADMS_Measurement()
    
    public func configure() -> AppConfiguration? {
        guard let rs = self.remoteSession else {
            fatalError("AppConfigurator - configure error")
        }
        let configuration = AppConfiguration()
        
        // archive type
        var appAchiveType: STAppArchiveType = .inHouse
        if Bundle.main.bundleIdentifier ~= "ca.bellmedia.snackabletv" {
            appAchiveType = .bellMedia
        } else {
            appAchiveType = .inHouse
        }
        
        // setup remote settings
        configuration.setObject(rs, forKey: "remoteSession" as NSCopying)
        
        // setup sync coordinator
        if let sc = self.syncCoordinator {
            configuration.setObject(sc, forKey: "syncCoordinator" as NSCopying)
        }
        
        self.configureUA(byAchiveType: appAchiveType)
        self.configureOmniture()
        
        // fabric
        Fabric.with([Crashlytics.self])
        
        // HockeyApp
        BITHockeyManager.shared().configure(withIdentifier: "4914804cbe4940679f1de505e268c1b2")
        // Do some additional configuration if needed here
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()

        //Gigya.initWithAPIKey("3_mrFGNf8yi6uKBfvHPq_O8JKK3uOXW7yuDCF9rscp_ey2XEU5SRxNlPvLD76PDukG", application: application, launchOptions: launchOptions)
        return configuration
    }
}


let kAppConfigurationRemoteSession = "remoteSession"
let kAppConfigurationSyncCoordinator = "syncCoordinator"

typealias AppConfiguration = NSMutableDictionary // subclass dictionary would require override methods

extension AppConfiguration {
    
    var isValid: Bool {
        get {
            if let _ = self[kAppConfigurationRemoteSession] as? ACRemoteSession,
                let _ = self[kAppConfigurationSyncCoordinator] as? ACSyncCoordinator
            {
                return true
            } else {
                return false
            }
        }
    }
    
    static func appVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    static func appBuild() -> String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
    
    static func versionWithBuild() -> String {
        return String(format: "%@ (%@)", self.appVersion(), self.appBuild())
    }
}

