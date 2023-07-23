//
//  CommodityVoucherTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class CommodityVoucherTableViewCell: UITableViewCell {
    
    static let identifier = "CommodityVoucherTableViewCell"
    
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
    
    func setCell(commodityVoucherInfo:CommodityVoucherInfo) {
        let data = try? Data(contentsOf: URL(string: commodityVoucherInfo.picture)!)
        let activityStartTimeDate = dateFromString(commodityVoucherInfo.activityStartTime)
        let activityEndTimeDate = dateFromString(commodityVoucherInfo.activityEndTime)
        let StartDate = getDates(i: 0, currentDate: activityStartTimeDate!).0
        let EndDate = getDates(i: 0, currentDate: activityEndTimeDate!).0
        DispatchQueue.main.async { [self] in
            if let data = data, let image = UIImage(data: data) {
                itemImageView.image = image
            }
            itemName.text = commodityVoucherInfo.itemName
            duringTime.text = "活動時間:" + StartDate + "~" + EndDate
            drawTime.text = "開獎日期:" + EndDate
            drawPeople.text = "參與人數:" + String(commodityVoucherInfo.purchaserCount)
            duringTime.font = duringTime.font.withSize(11)
            drawTime.font = duringTime.font.withSize(11)
            point.text = "\(commodityVoucherInfo.itemPrice)"
        }
    }

}
