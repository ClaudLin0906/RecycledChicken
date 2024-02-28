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
        DispatchQueue(label: "com.geek-is-stupid.queue.configure-cell").async {
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
                drawTime.text = "使用時間:" + StartDate + "~" + EndDate
                drawPeople.text = "剩餘數量:" + String(commodityVoucherInfo.purchaserCount)
                drawTime.font = drawTime.font.withSize(11)
                point.text = "\(commodityVoucherInfo.itemPrice)"
            }
        }
    }

}
