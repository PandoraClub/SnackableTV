//
//  ACRemote.swift
//  <?>App
//
//  Created by Austin Chen on 2016-04-26.
//

import Foundation
import CoreData

protocol ACRemoteRecordSyncableType {
    var id: Int64 { get }
}

enum ACRemoteRecordChange<T: ACRemoteRecordSyncableType> {
    case found(T, NSManagedObjectID)
    case inserted(T, NSManagedObjectID)
    case removed
    
    var isInserted: Bool {
        switch self {
        case .inserted:
            return true
        default:
            return false
        }
    }
    var isFound: Bool {
        switch self {
        case .found:
            return true
        default:
            return false
        }
    }
    var isRemoved: Bool {
        switch self {
        case .removed:
            return true
        default:
            return false
        }
    }
}

import Alamofire

/* remote settings
 */
struct ACRemoteSettings {
    static let serialQueue: DispatchQueue = DispatchQueue(label: "com.ac.snackabletv.remote-serial-queue", attributes: [])
    static let concurrentQueue: DispatchQueue = DispatchQueue(label: "com.ac.snackabletv.remote-concurrent-queue", attributes: DispatchQueue.Attributes.concurrent)
}

/// All Remote subclasses fetch remote data ASYNCHRONOUSLY, so be aware the completion block is NOT executed on main thread

class ACSimpleRemote: NSObject {
    // api version
    let apiVersion = "1.0.0"
    
    // domains
    let domain: String
    
    // base urls
    var baseUrl: String
    static var stBaseUrl: String {
        return ""
    }
    
    var alamoFireManager: SessionManager = ACSessionManager.shared
    
    override init() {
        domain = "localhost"
        baseUrl = "https://" + domain
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            domain: .disableEvaluation
        ]
        alamoFireManager = SessionManager(configuration: URLSessionConfiguration.default,
                                          serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        
        super.init()
    }
}

class ACRemote: ACSimpleRemote {
    let isRetryEnabled = false
    let remoteSession: ACRemoteSessionType?
    
    init(remoteSession: ACRemoteSession?) {
        self.remoteSession = remoteSession
        
        super.init()
        
        if let d = self.remoteSession?.domain {
            baseUrl = ACSettings.shared.host.prefixUrl
        }
        
        if isRetryEnabled,
            let rs = self.remoteSession
        {
            // configure adapter and retry
            /*let retryHandler = ACRemoteRetryHandler(domain: rs.domain, accessToken: rs.accessToken)
            alamoFireManager.adapter = retryHandler
            alamoFireManager.retrier = retryHandler*/ // Todo
        } else {
            print("error: ACRemoteRetryHandler not configured")
        }
    }
}

// for AlamoFire 4.0 + 

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

