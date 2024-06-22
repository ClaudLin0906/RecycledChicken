//
//  InvitedTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/25.
//

import UIKit
import M13Checkbox
class InvitedTableViewCell: UITableViewCell {
    
    static let identifier = "InvitedTableViewCell"
    
    @IBOutlet weak var InviteCodeTitle:UILabel!
    
    @IBOutlet weak var checkBox:M13Checkbox!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkBox.boxType = .square
        checkBox.checkState = .checked
        checkBox.stateChangeAnimation = .fill
        checkBox.isEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ Invited:String) {
        
    }

}
