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
        amountLabel.textAlignment = .right
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(_ date: Date, bottle: Int? = nil, battery: Int? = nil, can: Int? = nil, cup: Int? = nil, hdpeBottle: Int? = nil, foilPack: Int? = nil, cartonBox: Int? = nil) {
        calendarLabel.text = getDates(i: 0, currentDate: date).0
        
        if let bottle = bottle {
            recycledItemLabel.text = RecycleItem.bottle.chineseName
            amountLabel.text = "瓶數:\(bottle)"
        } else if let battery = battery {
            recycledItemLabel.text = RecycleItem.battery.chineseName
            amountLabel.text = "個數:\(battery)"
        } else if let can = can {
            recycledItemLabel.text = RecycleItem.aluminumCan.chineseName
            amountLabel.text = "罐數:\(can)"
        } else if let cup = cup {
            recycledItemLabel.text = RecycleItem.papperCub.chineseName
            amountLabel.text = "個數:\(cup)"
        } else if let hdpeBottle = hdpeBottle {
            recycledItemLabel.text = RecycleItem.hdpeBottle.chineseName
            amountLabel.text = "個數:\(hdpeBottle)"
        } else if let foilPack = foilPack {
            recycledItemLabel.text = RecycleItem.foilPack.chineseName
            amountLabel.text = "個數:\(foilPack)"
        } else if let cartonBox = cartonBox {
            recycledItemLabel.text = RecycleItem.cartonBox.chineseName
            amountLabel.text = "個數:\(cartonBox)"
        }
    }

}
