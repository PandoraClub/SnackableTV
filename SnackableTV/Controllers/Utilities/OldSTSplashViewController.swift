//
//  OldSTSplashViewController.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-03.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class OldSTSplashViewController: UIViewController {
    
    var mainUser: GigyaUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gsRequest = GSRequest(forMethod: "accounts.getAccountInfo")
        gsRequest?.send(responseHandler: { (response, error) in
            if let v = response?.object(forKey: "statusReason") as? String,
                v == "OK"
            {
                self.getUser(response: response)
                self.proceedToLoggedInController()
            } else {
                self.proceedToLoggedOutController()
            }
        })
    }

    func getUser(response: GSResponse?) {
        guard let response = response else { return }
        
        mainUser = GigyaUser()
        if let obj = response.object(forKey: "profile") as? GSResponse {
            if let email = obj.object(forKey: "email") as? String {
                mainUser?.userEmail = email
            }
            
            if let fn = obj.object(forKey: "firstName") as? String {
                mainUser?.userFirstName = fn
            }
            
            if let ln = obj.object(forKey: "lastName") as? String {
                mainUser?.userLastName = ln
            }
            
            if let pUrl = obj.object(forKey: "photoURL") as? String {
                mainUser?.profilePicURL = pUrl
            }
        }
    }
    
    func proceedToLoggedOutController() {
        let controller = STStoryboardFactory.loginStoryboard.instantiateViewController(withIdentifier: "welcomeVC")
        self.present(controller, animated: false, completion: nil)
    }
    
    func proceedToLoggedInController() {
        let controller = STStoryboardFactory.mainStoryboard.instantiateViewController(withIdentifier: "mainContainerVC")
        self.present(controller, animated: true, completion: nil)
    }
}
