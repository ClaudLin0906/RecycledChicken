//
//  CommodityVoucherTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit
import Kingfisher
class CommodityVoucherTableViewCell: UITableViewCell {
    
    static let identifier = "CommodityVoucherTableViewCell"
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemNameLabel: CustomLabel!
        
    @IBOutlet weak var pointLabel: UILabel!
        
    @IBOutlet weak var drawTimeLabel: CustomLabel!
    
    @IBOutlet weak var drawPeopleLabel:CustomLabel!
    
    private var itemImageURL:URL?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [self] in
                    itemImageView.kf.setImage(with: newValue)
                }
            }
        }
    }
    
    private var itemName:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [self] in
                    itemNameLabel.text = newValue
                }
            }
        }
    }
    
    private var duringTime:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [self] in
                    drawTimeLabel.text = newValue
                }
            }
        }
    }
    
    private var drawPeople:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [self] in
                    drawPeopleLabel.text = newValue
                }
            }
        }
    }
    private var point:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [self] in
                    pointLabel.text = newValue
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ commodityVoucherInfo:CommodityVoucherInfo) {
        DispatchQueue(label: "com.geek-is-stupid.queue.configure-cell").async {
            
            if let pictureStr = commodityVoucherInfo.picture, let pictureURL = URL(string: pictureStr) {
                self.itemImageURL = pictureURL
            }
            
            if let itemName = commodityVoucherInfo.name {
                self.itemName = itemName
            }
            
            var startTime:String?
            var endTime:String?
            
            if let start = commodityVoucherInfo.start {
//                let activityStartTimeDate = dateFromString(eventStartTime)
//                startTime = getDates(i: 0, currentDate: activityStartTimeDate!).0
                startTime = start
            }
            
            if let end = commodityVoucherInfo.end {
//                let activityEndTimeDate = dateFromString(eventEndTime)
//                endTime = getDates(i: 0, currentDate: activityEndTimeDate!).0
                endTime = end
            }
            
            if let startTime = startTime, let endTime = endTime {
                self.duringTime = "validDate".localized + ":" + startTime + "~" + endTime
            }
            
            if let remainingQuantity = commodityVoucherInfo.remainingQuantity {
                self.drawPeople =  "remain".localized + String(remainingQuantity)
            }
            
            if let points = commodityVoucherInfo.points {
                self.point = String(points)
            }
        }
    }

}
