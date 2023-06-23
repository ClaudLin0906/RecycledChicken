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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(info:RecycleLogInfo) {
        calendarLabel.text = info.time
    }

}
