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
        let data = try? Data(contentsOf: URL(string: lotteryInfo.picture)!)
        let activityStartTimeDate = dateFromString(lotteryInfo.activityStartTime)
        let activityEndTimeDate = dateFromString(lotteryInfo.activityEndTime)
        let StartDate = getDates(i: 0, currentDate: activityStartTimeDate!).0
        let EndDate = getDates(i: 0, currentDate: activityEndTimeDate!).0
        DispatchQueue.main.async { [self] in
            if let data = data, let image = UIImage(data: data) {
                itemImageView.image = image
            }
            itemName.text = lotteryInfo.itemName
            duringTime.text = "活動時間:" + StartDate + "~" + EndDate
            drawTime.text = "開獎日期:" + EndDate
            duringTime.font = duringTime.font.withSize(11)
            drawTime.font = duringTime.font.withSize(11)
        }
    }

}
