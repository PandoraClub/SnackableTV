//
//  STKeyStore.swift
//  ?<app>
//
//  Created by Austin Chen on 2016-09-18.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import Foundation
import Locksmith

/* using both NSUserDefaults and Keychain for user session life cycle + security
 */
let kUserDefaultKey = "kSnackableTVUserDefaultKey" // Pro: removed when app uninstalls, prefect for the case checking whether user should be auto signed in, Con: plain text

struct STKeyStoreItem {
    var appInstalled: Bool
}

class STKeyStore: NSObject {
    static let kLocksmithUserAccountName = "kSnackableTVAccountName" // Pro: secure.
    
    static var keyStoreItem: STKeyStoreItem? {
        get {
            guard let _ = UserDefaults.standard.object(forKey: kUserDefaultKey) else {
                return nil // app is either never installed, or deleted
            }
            if let dict = Locksmith.loadDataForUserAccount(userAccount: kLocksmithUserAccountName) {
                if let _ = dict["kAppInstalled"] as? Bool {
                    return STKeyStoreItem(appInstalled: true)
                } else {
                    return nil
                }
            } else {
                print("Error: HAPKeyStore - item is registered in NSUserDefaults, but not present in Keychain")
                return nil
            }
        }
        set {
            if let item = newValue {
                let dict: [String : Any] = ["kAppInstalled": true]
                do {
                    if let _ = Locksmith.loadDataForUserAccount(userAccount: kLocksmithUserAccountName) {
                        try Locksmith.updateData(data: dict, forUserAccount: kLocksmithUserAccountName)
                    } else {
                        try Locksmith.saveData(data: dict, forUserAccount: kLocksmithUserAccountName)
                    }
                } catch let error as NSError {
                    print("Error: STKeyStore - %@", error)
                }
                UserDefaults.standard.set(NSNumber(value: true as Bool), forKey: kUserDefaultKey)
                UserDefaults.standard.synchronize()
            } else {
                do {
                    try Locksmith.deleteDataForUserAccount(userAccount: kLocksmithUserAccountName)
                } catch let error as NSError {
                    print("Error: STKeyStore - %@", error)
                }
                UserDefaults.standard.removeObject(forKey: kUserDefaultKey)
                UserDefaults.standard.synchronize()
            }
        }
    }
}

extension STKeyStore {
    static var isAppFirstLaunch: Bool { // by APIKey
        if STKeyStore.keyStoreItem != nil {
            return false
        } else {
            return true
        }
    }
}
