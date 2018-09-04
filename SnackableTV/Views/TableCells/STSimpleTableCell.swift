//
//  STSimpleTableCell.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-04-13.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

class STSimpleTableCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
