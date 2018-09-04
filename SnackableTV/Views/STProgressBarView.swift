//
//  STProgressBarView.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-05-02.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class STProgressBarView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var fillingView: UIView!
    @IBOutlet weak var fillingViewConstraintWidth: NSLayoutConstraint!
    
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
        let nib = UINib(nibName: "STProgressBarView", bundle: bundle)
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
        progressPercentage = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = self.bounds
    }

    var fillingLength: CGFloat {
        get {
            return fillingViewConstraintWidth.constant
        }
        set {
            // bound to range of 0 ... self.bounds.width
            var nv = newValue
            nv = max(0, nv)
            nv = min(self.bounds.width, nv)
            
            fillingViewConstraintWidth.constant = nv
            setNeedsUpdateConstraints()
        }
    }
    
    var progressPercentage: Float {
        get {
            return Float(self.fillingView.frame.width / self.frame.width)
        }
        set {
            guard newValue > 0, newValue <= 1 else { return }
            
            let newWidth = self.bounds.width * CGFloat(newValue)
            self.fillingLength = newWidth
        }
    }
}
