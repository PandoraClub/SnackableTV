//
//  ACSettings.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-07.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

class ACSettings {
    
    static let shared: ACSettings = {
        let instance = ACSettings()
        
        // setup code
        let defaults = UserDefaults.standard
        
        return instance
    }()
    
    var uniqueAppId: String = { // created once per install; AppStore forbids UDID;
        let k = "kKeyAppUniqueId"
        if UserDefaults.standard.object(forKey: k) == nil {
            UserDefaults.standard.set(UUID().uuidString, forKey: k)
            UserDefaults.standard.synchronize()
        }
        return UserDefaults.standard.object(forKey: k) as! String
    }()
    
    var locale: String {
        var l = "en-ca"
        if let lang = NSLocale.preferredLanguages.first,
            lang.contains("fr")
        {
            l = "fr-ca" // Canada French
        }
        return l
    }
    
    // MARK: in-app settings
}

// in-app settings

extension ACSettings {
    var host: ACHost {
        set {
            let s = newValue.name + "@" + newValue.domain
            UserDefaults.standard.set(s, forKey: kKeyHost)
            UserDefaults.standard.synchronize()
        }
        
        get {
            if let hostString = UserDefaults.standard.object(forKey: kKeyHost) as? String {
                let a = hostString.components(separatedBy: "@")
                return ACHost(name: a[0], domain: a[1])
            } else {
                let h = ACHost.hosts[0]  // use Prod as default
                self.host = h
                return h
            }
        }
    }
}

// debug settings
fileprivate let kKeyHost = "kACSettingsKeyHost"

protocol ACSettingsBundleType {
    func registerDefaultSettings()
    func isDebugEnabled() -> Bool
}

/* Settings.bundle is only included for debug build, for now
 if the inclusiveness changes, it requires Clean before Building the binary
 for detail, please look at Build Phases -> Run Script (after Copy Bundle Resources)
 */
extension ACSettings: ACSettingsBundleType {
    
    func registerDefaultSettings() {
        let defaults = UserDefaults.standard
        let settingsDict = [kIdContextualDebugging: "NO"]
        
        defaults.register(defaults: settingsDict)
        defaults.synchronize()
    }
    
    func isDebugEnabled() -> Bool {
        let bool = UserDefaults.standard.bool(forKey: kIdContextualDebugging)
        return bool
    }
}

fileprivate let kIdContextualDebugging: String = "IdContextDebugging"
