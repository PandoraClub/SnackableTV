//
//  STContentPackageProcessor.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-25.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import CoreData

protocol STContentPackageProcessorType: ACSyncableProcessorType {
}

@objc class STContentPackageProcessor: NSObject, STContentPackageProcessorType {
    let syncContext: ACSyncContext
    
    required init (context: ACSyncContext) {
        self.syncContext = context
    }
    
    lazy var contentPackageRemote: STContentPackageRemoteType = {
        return STContentPackageRemote(remoteSession: self.syncContext.remoteSession)
    }()
    
    func sync(_ completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: Error?) -> ()) {
    }
}
