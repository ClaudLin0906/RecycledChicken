//
//  PersonMessageTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/9.
//

import UIKit

class PersonMessageTableViewCell: UITableViewCell {
    
    static let identifier = "PersonMessageTableViewCell"
    
    @IBOutlet weak var titleLabel:CustomLabel!
    
    @IBOutlet weak var timeLabel:CustomLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ personMessageInfo:PersonMessageInfo) {
        titleLabel.text = "\(personMessageInfo.title) \(personMessageInfo.message)"
        if let date = dateFromString(personMessageInfo.createTime) {
            let dateStr = getDates(i: 0, currentDate: date).0
            timeLabel.text = dateStr
        }
    }

}
