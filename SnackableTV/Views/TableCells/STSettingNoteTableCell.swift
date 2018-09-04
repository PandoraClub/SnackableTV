//
//  STSettingNoteTableCell.swift
//  SnackableTV
//
//  Created by Austin Chen on 2017-05-03.
//  Copyright © 2017 Austin Chen. All rights reserved.
//

import UIKit

protocol STSettingNoteTableCellDelegate: class {
    func didTapOnOffSwitch(atIndex index: Int, mode: Bool)
}

class STSettingNoteTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightSwitch: UISwitch!
    weak var delegate: STSettingNoteTableCellDelegate?
    @IBAction func switched(_ sender: Any) {
        delegate?.didTapOnOffSwitch(atIndex: self.tag, mode: rightSwitch.isOn)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
