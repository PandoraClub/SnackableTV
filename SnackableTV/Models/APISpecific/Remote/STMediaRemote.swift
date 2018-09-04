//
//  STMediaRemote.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-25.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import Alamofire

protocol STMediaRemoteType {
    func fetchMedias(byPath path: String, _ completion: @escaping (_ result: ACRemoteResult<STJsonItems<STJsonMedia>>) -> ())
}

class STMediaRemote: ACRemote, STMediaRemoteType {
    
    func fetchMedias(byPath path: String, _ completion: @escaping (_ result: ACRemoteResult<STJsonItems<STJsonMedia>>) -> ()) {
        // pass empty dict to trigger custom encoding routines
        let includeAll = "?$include=*"
        
        let request = self.alamoFireManager.request(self.baseUrl + path + "/medias" + includeAll, headers: self.remoteSession?.postAuthenticationHttpHeaders)
        
        request.responseObject(queue: ACRemoteSettings.concurrentQueue) { (response: DataResponse<STJsonItems<STJsonMedia>>) in
            if response.isValid,
                let v = response.result.value {
                completion(ACRemoteResult.success(v))
            } else {
                completion(ACRemoteResult.failure(response.error))
            }
        }
    }
}
