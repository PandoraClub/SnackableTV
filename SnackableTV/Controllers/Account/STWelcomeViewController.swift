//
//  STWelcomeViewController.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-03.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class STWelcomeViewController: UIViewController {
    
    var mainUser: GigyaUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        let params = ["screenSet": "Default-RegistrationLogin"]
        Gigya.showPluginDialogOver(self, plugin: "accounts.screenSet", parameters: params) { (closedByUser, error) in
            if !closedByUser, error == nil {
                print("Login was successful")
                let gsRequest = GSRequest(forMethod: "accounts.getAccountInfo")
                gsRequest?.send(responseHandler: { (response, error) in
                    self.getUser(response: response)
                    self.proceedToLoggedInController()
                })
            } else if let e = error as? NSError, e.code == 206001 {
                // Handle user account pending registration. User info already exists in user object.
                print(e)
            } else {
                // Handle error
                print("error")
            }
        }
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
    
    func proceedToLoggedInController() {
        let controller = STStoryboardFactory.loginStoryboard.instantiateViewController(withIdentifier: "mainContainerVC")
        self.present(controller, animated: true, completion: nil)
    }
}
