//
//  STContentPackageRemote.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-21.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import Alamofire

protocol STContentPackageRemoteType {
    func fetchContentPackage(byPath path: String, _ completion: @escaping (_ result: ACRemoteResult<STJsonContentPackage>) -> ())
    func fetchContentPackage(byAbsolutePath path: String, _ completion: @escaping (_ result: ACRemoteResult<STJsonContentPackage>) -> ())
}

class STContentPackageRemote: ACRemote, STContentPackageRemoteType {
    
    // needed because fetch multiple packages does not return info like Security.Type
    func fetchContentPackage(byPath path: String, _ completion: @escaping (_ result: ACRemoteResult<STJsonContentPackage>) -> ()) {
        self.fetchContentPackage(byAbsolutePath: self.baseUrl + path, completion)
    }
    
    func fetchContentPackage(byAbsolutePath path: String, _ completion: @escaping (_ result: ACRemoteResult<STJsonContentPackage>) -> ()) {
        let request = self.alamoFireManager.request(path, headers: self.remoteSession?.postAuthenticationHttpHeaders)
        
        request.responseObject(queue: ACRemoteSettings.concurrentQueue) { (response: DataResponse<STJsonContentPackage>) in
            if response.isValid,
                let v = response.result.value {
                completion(ACRemoteResult.success(v))
            } else {
                completion(ACRemoteResult.failure(response.error))
            }
        }
    }
}
