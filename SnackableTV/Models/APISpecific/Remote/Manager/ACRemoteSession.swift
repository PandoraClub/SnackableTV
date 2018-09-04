//
//  ACRemoteSession.swift
//  <?>App
//
//  Created by Austin Chen on 2016-04-27.
//

import Foundation

typealias RemoteSessionUserInfo = (id: String, name: String)

protocol ACRemoteSessionType {
    var postAuthenticationHttpHeaders: [String:String] {get}
    var domain: String {get}
}

class ACRemoteSession: ACRemoteSessionType {
    static let preAuthenticationHttpHeaders = [
        "Accept":"*/*",
        "Accept-Language":"en-us",
        "Content-Type":"application/json"]
    
    let domain: String
    
    init(domain: String) {
        self.domain = domain
    }
    
    var postAuthenticationHttpHeaders: [String:String] {
        get {
            var postHeaders = ACRemoteSession.preAuthenticationHttpHeaders
            postHeaders["Content-Type"] = "application/json"
            //postHeaders["Authorization"] = "Bearer " + self.accessToken
            return postHeaders
        }
    }
    
    /*
    func isExpired() -> Bool {
        if Date().compare(expiration) == .orderedAscending {
            return false
        } else {
            return true
        }
    }*/
}
