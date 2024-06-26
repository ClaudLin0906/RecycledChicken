//
//  ProfileTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/9.
//

import UIKit
import M13Checkbox
class ProfileTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileTableViewCell"
    
    @IBOutlet weak var infoTitle:UILabel!
    
    @IBOutlet weak var phoneNumberCheckBox:M13Checkbox!
    
    @IBOutlet weak var info:UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        phoneNumberCheckBox.boxType = .square
        phoneNumberCheckBox.stateChangeAnimation = .fill
        phoneNumberCheckBox.isEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        info.placeholder = "未填寫"
        info.inputView = nil
        info.inputAccessoryView = nil
        info.isEnabled = true
        info.keyboardType = .default
        phoneNumberCheckBox.isHidden = true
    }


}
