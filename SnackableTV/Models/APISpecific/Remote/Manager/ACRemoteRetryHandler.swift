//
//  ACRemoteRetryHandler.swift
//  <?>App
//
//  Created by Austin Chen on 2016-11-08.
//  Copyright © 2016 10.1. All rights reserved.
//

import Foundation
import Alamofire

class ACRemoteRetryHandler: RequestAdapter {
    
    fileprivate var domain: String
    fileprivate var accessToken: String
    
    fileprivate let lock = NSLock()
    fileprivate var requestsToRetry: [RequestRetryCompletion] = []
    
    // MARK: - Initialization
    
    public init(domain: String, accessToken: String) {
        self.domain = domain
        self.accessToken = accessToken
    }
    
    // MARK: instance methods
    /*
    lazy var authenticationRemote: ACAuthenticationRemoteType = {
        return ACAuthenticationRemote()
    }()
    */
    // MARK: - RequestAdapter
    
    public func adapt(_ urlRequest: URLRequest) -> URLRequest {
        if let has = urlRequest.url?.absoluteString.hasPrefix(domain), has == true {
            var mutableURLRequest = urlRequest
            mutableURLRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            return mutableURLRequest
        }
        return urlRequest
    }
}

extension ACRemoteRetryHandler: RequestRetrier {
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
    
    // MARK: - RequestRetrier
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion)
    {
        guard let response = request.task?.response as? HTTPURLResponse else
        {
            completion(false, 0.0)
            return
        }
        /*
        lock.lock() ; defer { lock.unlock() }
        
        if response.statusCode == 401 {
            guard let keyStoreItem = ACKeyStore.keyStoreItem, keyStoreItem.isExpired() else {
                print("error: API call failed by authenticaion, but access token is not expired.")
                return
            }
            
            requestsToRetry.append(completion)
            
            // meaning an valid session does not exist, so user needs to refresh token, or login
            self.authenticationRemote.refreshAccessToken(keyStoreItem.refreshToken) { (result) in
                self.lock.lock() ; defer { self.lock.unlock() }
                
                // store new access token & refresh token
                if result.isSuccess,
                    let li = result.value,
                    let si = li.sessionInfo, si.isValid()
                {
                    // key the session info in keystore across multiple app launches
                    let remoteSession = ACRemoteSession(domain: self.domain,
                                                         userInfo: (id: keyStoreItem.userInfo.id,
                                                                    name: keyStoreItem.userInfo.name),
                                                         credentials: (accessToken: si.accessToken!,
                                                                       refreshToken: si.refreshToken!,
                                                                       expiration: si.expiration!) )
                    ACKeyStore.keyStoreItem = remoteSession
                    
                    self.requestsToRetry.forEach { $0(result.isSuccess, 0.0) }
                    self.requestsToRetry.removeAll()
                }
            }
        } else if response.statusCode == 403 { // assume 403 is network problem
            print("ac: placeholder")
            completion(false, 0.0)
        } else {
            completion(false, 0.0)
        }
         */
    }
}
