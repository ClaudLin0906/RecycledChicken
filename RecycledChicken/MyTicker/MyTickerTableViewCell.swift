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
    
    func setCell(_ info:MyTickertLotteryInfo){
        itemName.text = info.itemName
        drawTime.text = "開獎時間:\(info.lotteryDrawDate ?? "")"
        UUID.text = info.UUID
    }

}
