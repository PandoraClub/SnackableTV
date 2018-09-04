//
//  STself.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-05-03.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

protocol STCustomNavBarViewDelegate: class {
    func backButtonTapped()
    func leftButtonTapped()
    func rightButtonTapped()
}

class STCustomNavBarView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backBarButtonConstraintWidth: NSLayoutConstraint!
    @IBOutlet weak var backBarButton: UIButton!
    @IBAction func backBarButtonTapped(_ sender: Any) {
        delegate?.backButtonTapped()
    }
    
    @IBOutlet weak var leftBarButton: UIButton!
    @IBAction func leftBarButtonTapped(_ sender: Any) {
        delegate?.leftButtonTapped()
    }
    
    @IBOutlet weak var rightBarButton: UIButton!
    @IBAction func rightBarButtonTapped(_ sender: Any) {
        delegate?.rightButtonTapped()
    }
    
    weak var delegate: STCustomNavBarViewDelegate?
    
    // MARK: life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "STCustomNavBarView", bundle: bundle)
        let contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.addSubview(contentView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // add the missing contrainst between xib contentView to self
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.setNeedsUpdateConstraints()
        
        // self.translatesAutoresizingMaskIntoConstraints = true
        
        backBarButtonConstraintWidth.constant = 0
        self.backBarButton.superview?.setNeedsUpdateConstraints()
        backBarButton.isUserInteractionEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = self.bounds
    }

    // MARK: instance methods
    
    func updateDisplay(byNavBarItem customNavBarItem: STCustomNavBarItem) {
        self.backBarButtonConstraintWidth.constant = customNavBarItem.isBackButtonHidden ? 0 : 15.0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundBlurView.contentView.backgroundColor = customNavBarItem.backgroundColor
            self.titleLabel.text = customNavBarItem.title
            self.backBarButton.superview?.layoutIfNeeded()
            self.rightBarButton.alpha = customNavBarItem.isRightBarButtonHidden ? 0 : 1.0
        }, completion: { finished in
            self.backBarButton.isUserInteractionEnabled = !customNavBarItem.isBackButtonHidden
            self.rightBarButton.isHidden = customNavBarItem.isRightBarButtonHidden
        })
    }
}

fileprivate let kBlueColor = UIColor(red: 0, green: 136/255.0, blue: 255/255.0, alpha: 0.8)
fileprivate let kBlackColor = UIColor(white: 0, alpha: 0.8)
