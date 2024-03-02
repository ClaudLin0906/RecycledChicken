//
//  PartnerMerchantsTableViewTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/28.
//

import UIKit

class PartnerMerchantsTableViewTableViewCell: UITableViewCell {
    
    static let identifier = "PartnerMerchantsTableViewTableViewCell"
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemName: CustomLabel!
        
    @IBOutlet weak var point: UILabel!
    
    @IBOutlet weak var duringTime: CustomLabel!
    
    @IBOutlet weak var drawTime: CustomLabel!
    
    @IBOutlet weak var drawPeople:CustomLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ lotteryInfo:LotteryInfo) {
        DispatchQueue(label: "com.geek-is-stupid.queue.configure-cell").async {
//            let data = try? Data(contentsOf: URL(string: lotteryInfo.picture)!)
            let activityStartTimeDate = dateFromString(lotteryInfo.activityStartTime)
            let activityEndTimeDate = dateFromString(lotteryInfo.activityEndTime)
            let StartDate = getDates(i: 0, currentDate: activityStartTimeDate!).0
            let EndDate = getDates(i: 0, currentDate: activityEndTimeDate!).0
            let lotteryDrawDate = lotteryInfo.lotteryDrawDate
            DispatchQueue.main.async { [self] in
                if let url = URL(string: lotteryInfo.picture) {
                    itemImageView.kf.setImage(with: url)
                }
                itemName.text = lotteryInfo.itemName
                duringTime.text = "活動時間:" + StartDate + "~" + EndDate
                drawTime.text = "使用日期:" + lotteryDrawDate
                drawPeople.text = "剩餘數量:" + String(lotteryInfo.purchaserCount)
                duringTime.font = duringTime.font.withSize(11)
                drawTime.font = duringTime.font.withSize(11)
                point.text = "\(lotteryInfo.itemPrice)"
            }
        }
    }
}
