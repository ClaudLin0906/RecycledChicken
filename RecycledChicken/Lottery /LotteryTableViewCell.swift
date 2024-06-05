//
//  LotteryTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit
import Kingfisher
class LotteryTableViewCell: UITableViewCell {
    
    static let identifier = "LotteryTableViewCell"

    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemNameLabel: CustomLabel!
        
    @IBOutlet weak var pointLabel: UILabel!
    
    @IBOutlet weak var duringTimeLabel: CustomLabel!
    
    @IBOutlet weak var drawTimeLabel: CustomLabel!
    
    @IBOutlet weak var drawPeopleLabel:CustomLabel!
    
    private var imageURL:URL?
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
                    duringTimeLabel.text = newValue
                }
            }
        }
    }
    
    private var lotteryDrawDate:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [self] in
                    drawTimeLabel.text = "duringDate".localized + ":" + newValue
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
    
    func setCell(_ lotteryInfo:LotteryInfo) {
        DispatchQueue(label: "com.geek-is-stupid.queue.configure-cell").async {
            
            if let productImageURLStr = lotteryInfo.productImage, let productImageURL = URL(string: productImageURLStr) {
                self.imageURL = productImageURL
            }
            
            if let itemName = lotteryInfo.itemName {
                self.itemName = itemName
            }
            
            var startTime:String?
            var endTime:String?
            if let eventStartTime = lotteryInfo.evnetStartTime {
                if let activityStartTimeDate = dateFromString(eventStartTime) {
                    startTime = getDates(i: 0, currentDate: activityStartTimeDate).0
                }else{
                    startTime = eventStartTime
                }
            }
            if let eventEndTime = lotteryInfo.eventEndTime {
                if let activityEndTimeDate = dateFromString(eventEndTime) {
                    endTime = getDates(i: 0, currentDate: activityEndTimeDate).0
                } else {
                    endTime = eventEndTime
                }
            }
            
            if let startTime = startTime, let endTime = endTime {
                self.duringTime = "activityTime".localized + ":" + startTime + "~" + endTime
            }
            
            if let drawDate = lotteryInfo.drawDate {
                self.lotteryDrawDate = drawDate
            }
            if let infoPoint = lotteryInfo.point {
                self.point = String(infoPoint)
            }
        }
    }
}
