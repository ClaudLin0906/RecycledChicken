//
//  SettingMenuTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class SettingMenuTableViewCell: UITableViewCell {
    
    static let identifier = "SettingMenuTableViewCell"
    
    @IBOutlet weak var iconImageView:UIImageView!
    
    @IBOutlet weak var title:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(info: settingMenuInfo) {
        
        if let icon = info.icon  {
            iconImageView.image = icon
        }
        
        title.text = info.title
    }
}
