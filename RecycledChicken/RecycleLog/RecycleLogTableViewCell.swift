//
//  RecycleLogTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/9.
//

import UIKit

class RecycleLogTableViewCell: UITableViewCell {
    
    static let identifier = "RecycleLogTableViewCell"
    
    @IBOutlet weak var calendarLabel:UILabel!
    
    @IBOutlet weak var recycledItemLabel:UILabel!
    
    @IBOutlet weak var amountLabel:UILabel!
    
    var infoTime:InfoTime?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(info:UseRecordInfo) {
        if let date = dateFromString(info.time) {
            calendarLabel.text = getDates(i: 0, currentDate: date).0
        }
        
        if let bottle = info.bottle {
            recycledItemLabel.text = "寶特瓶(PET)"
            amountLabel.text = String(bottle)
        }
        
        if let battery = info.battery {
            recycledItemLabel.text = "電池(BATT)"
            amountLabel.text = String(battery)
        }
        
    }

}
