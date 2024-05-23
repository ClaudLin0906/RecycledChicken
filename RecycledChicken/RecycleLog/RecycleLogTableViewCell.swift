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
    
    func setCell(_ date:Date, bottle:Int?, battery:Int?, can:Int?) {
        calendarLabel.text = getDates(i: 0, currentDate: date).0
        if let bottle = bottle {
            recycledItemLabel.text = "寶特瓶"
            amountLabel.text = "瓶數:\(bottle)"
        }
        
        if let battery = battery {
            recycledItemLabel.text = "電池"
            amountLabel.text = "個數:\(battery)"
        }
        
        if let can = can {
            recycledItemLabel.text = "紙杯"
            amountLabel.text = "杯數:\(can)"
        }
    
    }

}
