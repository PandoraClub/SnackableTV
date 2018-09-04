//
//  STCollectionRemote.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-05.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation
import Alamofire

protocol STCollectionRemoteType {
    func fetchCollections(byPath path: String, _ completion: @escaping (_ result: ACRemoteResult<STJsonItems<STJsonCollection>>) -> ())
}

class STCollectionRemote: ACRemote, STCollectionRemoteType {
    
    func fetchCollections(byPath path: String, _ completion: @escaping (_ result: ACRemoteResult<STJsonItems<STJsonCollection>>) -> ()) {
        // pass empty dict to trigger custom encoding routines
        let includeAll = "?$include=*"
        
        let request = self.alamoFireManager.request(self.baseUrl + path + "/collections" + includeAll, headers: self.remoteSession?.postAuthenticationHttpHeaders)
        
        request.responseObject(queue: ACRemoteSettings.concurrentQueue) { (response: DataResponse<STJsonItems<STJsonCollection>>) in
            if response.isValid,
                let v = response.result.value {
                completion(ACRemoteResult.success(v))
            } else {
                completion(ACRemoteResult.failure(response.error))
            }
        }
    }
}
