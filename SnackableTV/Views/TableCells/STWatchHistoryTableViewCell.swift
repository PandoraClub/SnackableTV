//
//  STWatchHistoryTableViewCell.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-05-01.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class STWatchHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var progressBarView: STProgressBarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var isFinishedWatching: Bool = false {
        didSet {
            if isFinishedWatching {
                imgView.alpha = 0.4
                titleLabel.textColor = UIColor(white: 1, alpha: 0.4)
                durationLabel.textColor = UIColor(white: 1, alpha: 0.4)
            } else {
                imgView.alpha = 1.0
                titleLabel.textColor = UIColor.white
                durationLabel.textColor = UIColor.white
            }
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isFinishedWatching = false
    }
}
