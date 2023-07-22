//
//  MyTickerTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

class MyTickerTableViewCell: UITableViewCell {
    
    static let identifier = "MyTickerTableViewCell"
    
    @IBOutlet weak var itemName:CustomLabel!
    
    @IBOutlet weak var drawTime:CustomLabel!
    
    @IBOutlet weak var UUID:CustomLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ info:MyTickertInfo){
        itemName.text = info.itemName
        if let date = dateFromString(info.buyTime) {
            drawTime.text = "開獎時間:\(getDates(i: 0, currentDate: date).0)"
        }
        UUID.text = info.UUID
    }

}
