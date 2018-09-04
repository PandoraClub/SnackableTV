//
//  STVideoPlayerView+ContentPackage.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-05-19.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import Foundation

extension STVideoPlayerView {
    func fetchVideoPackage(packagePath: String, completion: @escaping (Bool, String?)->()) {
        self.contentPackageRemote.fetchContentPackage(byAbsolutePath: packagePath) { (contentPackageResult) in
            DispatchQueue.main.async {
                guard contentPackageResult.isSuccess,
                    let contentPackage = contentPackageResult.value else
                {
                    completion(false, nil)
                    return
                }
                
                completion(true, contentPackage.securityType)
            }
        }
    }
}
