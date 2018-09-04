//
//  STLoaderTableCell.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-05-11.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class STLoaderTableCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
