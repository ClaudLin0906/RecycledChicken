//
//  ActivityVoucherTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/28.
//

import UIKit

class ActivityVoucherTableViewCell: UITableViewCell {
    
    static let identifier = "ActivityVoucherTableViewCell"
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemNameLabel: CustomLabel!
    
    @IBOutlet weak var pointLabel: UILabel!
    
    @IBOutlet weak var duringTimeLabel: CustomLabel!
    
    @IBOutlet weak var drawPeopleLabel:CustomLabel!
    
    @IBOutlet weak var hideView:UIView!
    
    @IBOutlet weak var hideViewTitleLabel:CustomLabel!
    
    @IBOutlet weak var hideViewDrawTimeLabel:CustomLabel!
    
    @IBOutlet weak var verityTextField:UITextField!
    
    @IBOutlet weak var verityLineButton:CustomButton!
    
    private var isUnlocked:Bool? = nil
    {
        willSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                hideView.isHidden = false
                if let newValue = newValue {
                    hideView.isHidden = newValue
                }
            }
        }
    }
    
    private var imageURL:URL?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    itemImageView.kf.setImage(with: newValue)
                }
            }
        }
    }
    
    private var itemName:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    itemNameLabel.text = newValue
                    hideViewTitleLabel.text = newValue
                }
            }
        }
    }
    
    private var duringTime:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    duringTimeLabel.text = newValue
                    hideViewDrawTimeLabel.text = newValue
                }
            }
        }
    }
    
    private var point:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    pointLabel.text = newValue
                }
            }
        }
    }
    
    private var drawPeople:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    drawPeopleLabel.text = "\(newValue)"
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let color = #colorLiteral(red: 0.5607843137, green: 0.7411764706, blue: 0.6705882353, alpha: 1)
        setPlaceholderColor(color)
        addUnderlineToVerityTextField(color)
        verityLineButton.layer.cornerRadius = verityLineButton.bounds.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setPlaceholderColor(_ color: UIColor) {
        if let placeholder = verityTextField.placeholder {
            verityTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: color]
            )
        } else {
            verityTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
    
    private func addUnderlineToVerityTextField(_ color: UIColor) {
        verityTextField.layer.sublayers?.filter { $0.name == "verityTextFieldUnderline" }.forEach { $0.removeFromSuperlayer() }
        let underline = CALayer()
        underline.name = "verityTextFieldUnderline"
        underline.backgroundColor = color.cgColor
        let onePixel = 1.0 / UIScreen.main.scale
        underline.frame = CGRect(x: 0, y: verityTextField.bounds.height - onePixel, width: verityTextField.bounds.width, height: onePixel)
        verityTextField.layer.addSublayer(underline)
    }
    
    func setCell(_ commodityVoucherInfo:CommodityVoucherInfo) {
        DispatchQueue(label: "com.geek-is-stupid.queue.configure-cell").async {
            
            self.isUnlocked = commodityVoucherInfo.isUnlocked
            
            if let productImageURLStr = commodityVoucherInfo.picture, let productImageURL = URL(string: productImageURLStr) {
                self.imageURL = productImageURL
            }
            
            if let itemName = commodityVoucherInfo.name {
                self.itemName = itemName
            }
            var startTime:String?
            var endTime:String?
            if let eventStartTime = commodityVoucherInfo.start {
                if let activityStartTimeDate = dateFromString(eventStartTime) {
                    startTime = getDates(i: 0, currentDate: activityStartTimeDate).0
                }else{
                    startTime = eventStartTime
                }
            }
            if let eventEndTime = commodityVoucherInfo.end {
                if let activityEndTimeDate = dateFromString(eventEndTime) {
                    endTime = getDates(i: 0, currentDate: activityEndTimeDate).0
                }else {
                    endTime = eventEndTime
                }
            }
            
            if let startTime = startTime, let endTime = endTime {
                self.duringTime = "activityTime".localized + ":" + startTime + "~" + endTime
            }
            
            if let infoPoint = commodityVoucherInfo.points {
                self.point = String(infoPoint)
            }
            
            if let peopleCount = commodityVoucherInfo.remainingQuantity {
                self.drawPeople = "剩餘數量 \(peopleCount)"
            }
            
        }
        
    }
    
}
