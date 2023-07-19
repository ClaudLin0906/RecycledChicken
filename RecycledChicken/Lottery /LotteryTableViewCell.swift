//
//  LotteryTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class LotteryTableViewCell: UITableViewCell {
    
    static let identifier = "LotteryTableViewCell"

    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemName: CustomLabel!
        
    @IBOutlet weak var point: UILabel!
    
    @IBOutlet weak var duringTime: CustomLabel!
    
    @IBOutlet weak var drawTime: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(lotteryInfo:LotteryInfo) {
        itemName.text = lotteryInfo.itemName
        if let data = try? Data(contentsOf: URL(string: lotteryInfo.picture)!) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.itemImageView.image = image
                }
            }
        }
        duringTime.text = lotteryInfo.activityStartTime + "~" + lotteryInfo.activityEndTime
    }

}
