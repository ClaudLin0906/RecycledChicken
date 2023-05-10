//
//  AccountTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    
    static let identifier = "AccountTableViewCell"
    
    @IBOutlet weak var title:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(_ info:accountTableViewInfo){
        title.text = info.title
    }

}
