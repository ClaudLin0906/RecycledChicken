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

    @IBOutlet weak var checkBoxWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        phoneNumberCheckBox.boxType = .square
        phoneNumberCheckBox.stateChangeAnimation = .fill
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
