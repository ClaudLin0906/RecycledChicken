//
//  ProfileTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/9.
//

import UIKit
import M13Checkbox

protocol ProfileTableViewCellDelegate {
    func longPress(_ gesture:UILongPressGestureRecognizer, inviteCode:String?)
}

class ProfileTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileTableViewCell"
    
    var delegate:ProfileTableViewCellDelegate?
    
    @IBOutlet weak var infoTitle:UILabel!
    
    @IBOutlet weak var phoneNumberCheckBox:M13Checkbox!
    
    @IBOutlet weak var info:UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        phoneNumberCheckBox.boxType = .square
        phoneNumberCheckBox.stateChangeAnimation = .fill
        phoneNumberCheckBox.isEnabled = false
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandle(_:)))
        addGestureRecognizer(longPress)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func longPressHandle(_ gesture:UILongPressGestureRecognizer) {
        delegate?.longPress(gesture, inviteCode: info.text)
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
