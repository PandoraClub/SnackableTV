//
//  STTermsConditionsViewController.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-05-14.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class STTermsConditionsViewController: UIViewController {

    @IBOutlet weak var customNavBarView: STCustomNavBarView!
    @IBOutlet weak var termsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.termsTextView.setContentOffset(CGPoint(x: 10,y :0), animated: false) //to show the contents from the top(looks like an apple issue, happens when 'editable' is OFF)

        // Do any additional setup after loading the view.
        self.customNavBarView.titleLabel.text = "Terms & Conditions".uppercased()
        self.customNavBarView.backgroundBlurView.contentView.backgroundColor = UIColor.clear
        self.customNavBarView.backgroundBlurView.effect = UIBlurEffect(style: .dark)
        
        self.customNavBarView.rightBarButton.isHidden = true
        
        self.customNavBarView.backBarButtonConstraintWidth.constant = 15
        self.customNavBarView.backBarButton.isUserInteractionEnabled = true
    
        self.customNavBarView.backBarButton.addTarget(self, action: #selector(backBarButton(_:)), for: .touchUpInside)
        
    }
    
    func backBarButton(_ target: Any?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
