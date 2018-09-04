//
//  STContentRemote.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-21.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import Alamofire

protocol STContentRemoteType {
    func fetchContents(byCollectionId id: Int64,
                       _ completion: @escaping (_ result: ACRemoteResult<STJsonBasicItems>) -> ())
    
    func fetchContents(byPath path: String, params: String?, _ completion: @escaping (_ result: ACRemoteResult<STJsonItems<STJsonContent>>) -> ())
}

// add arg place holder
extension STContentRemoteType {
    func fetchContents(byPath path: String, params: String? = nil, _ completion: @escaping (_ result: ACRemoteResult<STJsonItems<STJsonContent>>) -> ()) {
        return fetchContents(byPath: path, params: params, completion)
    }
}

class STContentRemote: ACRemote, STContentRemoteType {

    func fetchContents(byCollectionId id: Int64, _ completion: @escaping (_ result: ACRemoteResult<STJsonBasicItems>) -> ()) {
        // pass empty dict to trigger custom encoding routines
        let paginationParams = String(format: "?$page=%d&$top=%d", 1, 10)
        
        let request = self.alamoFireManager.request(self.baseUrl + "/collections/\(id)/contents" + paginationParams, headers: self.remoteSession?.postAuthenticationHttpHeaders)
        
        request.responseObject(queue: ACRemoteSettings.concurrentQueue) { (response: DataResponse<STJsonBasicItems>) in
            if response.isValid,
                let v = response.result.value {
                completion(ACRemoteResult.success(v))
            } else {
                completion(ACRemoteResult.failure(response.error))
            }
        }
    }
    
    func fetchContents(byPath path: String, params: String?, _ completion: @escaping (_ result: ACRemoteResult<STJsonItems<STJsonContent>>) -> ()) {
        let includeAll = "?$include=*" + (params ?? "")
        
        let request = self.alamoFireManager.request(self.baseUrl + path + "/contents" + includeAll, headers: self.remoteSession?.postAuthenticationHttpHeaders)
        
        request.responseObject(queue: ACRemoteSettings.concurrentQueue) { (response: DataResponse<STJsonItems<STJsonContent>>) in
            if response.isValid,
                let v = response.result.value {
                completion(ACRemoteResult.success(v))
            } else {
                completion(ACRemoteResult.failure(response.error))
            }
        }
    }
}
