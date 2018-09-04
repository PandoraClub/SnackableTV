//
//  ACSyncableJsonRecord.swift
//  <?>App
//
//  Created by Austin Chen on 2016-05-19.
//

import Foundation
import ObjectMapper

typealias ACSyncableKeyValuePairType = (key: String, value: AnyObject?)

class ACSyncableJsonRecord: NSObject, Mappable, ACRemoteRecordSyncableType {
    
    // MARK: app specific stored properties
    var id: Int64 = -1
    
    var order: Int = -1 // optional, ordering info
    var relationshipId: Int64? // optional, for adding relationship to parent

    override init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["Id"]
    }
}
