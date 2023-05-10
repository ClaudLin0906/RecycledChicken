//
//  SwitchTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    static let identifier = "SwitchTableViewCell"
    
    @IBOutlet weak var title:UILabel!
    
    @IBOutlet weak var turnOnOff:UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ info:switchTableViewInfo) {
        title.text = info.title
        turnOnOff.isOn = info.isTrue
    }

}
