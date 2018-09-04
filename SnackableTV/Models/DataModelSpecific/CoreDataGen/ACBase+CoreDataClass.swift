//
//  ACBase+CoreDataClass.swift
//  
//
//  Created by Austin Chen on 2017-04-05.
//
//

import Foundation
import CoreData

@objc(ACBase)
public class ACBase: NSManagedObject {
    
    func saveSyncableProperties(fromSyncable syncable: ACRemoteRecordSyncableType) {
        print("to be subclassed")
    }
}
