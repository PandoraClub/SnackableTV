//
//  STTableV3Cell.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-12.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class STTableV3Cell: UITableViewCell {
    
    @IBOutlet weak var topBorderConstraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var liveView: ACBorderedView!
    @IBOutlet weak var liveBeaconImageView: UIImageView!
    
    @IBOutlet weak var upNextLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var genreLogoImageView: UIImageView!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgGradientView: ACGradientBorderedView!
    @IBOutlet weak var uncensorView: ACBorderedView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imgView.contentMode = .center
        liveBeaconImageView.stopAnimating()
        
        topBorderConstraintHeight.constant = kTopBorderHeightNormal
        self.layoutIfNeeded()
    }
    
    var isUpNext: Bool = false {
        didSet {
            self.upNextLabel.isHidden = !isUpNext
        }
    }
    
    var isLiveStream: Bool = false {
        didSet {
            self.durationLabel.isHidden = isLiveStream
            // self.upNextLabel.isHidden = oldValue // TODO: hide for now
            self.liveView.isHidden = !isLiveStream
            
            if isLiveStream {
                var imgArray: [UIImage] = []
                
                for i in 0..<45 {
                    let n = String(format: "live-sig_%02d", i)
                    guard let img = UIImage(named: n) else { continue }
                    imgArray.append(img)
                }
                
                liveBeaconImageView.animationImages = imgArray
                liveBeaconImageView.animationRepeatCount = 0
                liveBeaconImageView.animationDuration = 1.5
                liveBeaconImageView.startAnimating()
            }
        }
    }
    
    var isUncensored: Bool = false {
        didSet {
            self.uncensorView.isHidden = !isUncensored
        }
    }
    
    func setGenre(title:String?, genreIcon iconName: String?) {
        if let iName = iconName {
            genreLogoImageView.sd_setImage(with: URL(string: iName))
            genreLabel.text = ""
        } else {
            genreLogoImageView.image = nil
            genreLabel.text = title
        }
    }
}

fileprivate let kTopBorderHeightBeforeAnim: CGFloat = 15.0
fileprivate let kTopBorderHeightNormal: CGFloat = 5.0
