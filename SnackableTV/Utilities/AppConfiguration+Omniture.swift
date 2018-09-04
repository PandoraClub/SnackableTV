//
//  AppConfiguration+Omniture.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-05-08.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import AirshipKit
import UIKit

extension AppConfigurator {
    func configureOmniture() {
        AppConfigurator.measurement.configureMeasurement(withReportSuiteIDs: "ctvgmsnackabletvios", trackingServer: "metrics.ctv.ca")
        AppConfigurator.measurement.ssl=false
        AppConfigurator.measurement.debugLogging=true
        AppConfigurator.measurement.setAutoTrackingOptions(ADMS_AutoTrackOptionsLifecycle)
        AppConfigurator.measurement.setAutoTrackingOptions(ADMS_AutoTrackOptionsNavigation)
    }
}
