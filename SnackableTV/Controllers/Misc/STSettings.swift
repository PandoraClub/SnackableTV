//
//  STSettings.swift
//  SnackableTV
//
//  Created by Thomas Varghese on 2017-05-12.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

public enum ConnectionType {
    case ethernetOrWiFi
    case wwan
}

let kVideoEnabledInWifi = "VideoEnabledInWifi"
let kWifiAlertMessage = "Your app settings only allow video streaming when connected to Wi-Fi. To enable video streaming over mobile data, update your settings"

//var isVideoOnWifiOnlyEnabled: Bool = false

class STSettings: NSObject {
    
    class func enableVideoOnWifiOnly(withMode mode: Bool) {
        
        UserDefaults.standard.setValue(mode, forKey: kVideoEnabledInWifi)
        
        //print("wifi Settings changed!")
    }
    
    class func isVideoOnWifiOnlyEnabled() -> Bool {

        if (UserDefaults.standard.bool(forKey: kVideoEnabledInWifi)) {
            return true
        }
        else {
            return false
        }

    }
    
}

