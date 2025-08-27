//
//  LotteryTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit
import Kingfisher

protocol LotteryTableViewCellDelegate {
    func lotteryHideImageEvent(_ link:String)
    func lotteryButtonEvent(_ name:String, _ category:String, _ veriftyCode:String, _ createTime:String)
}

class LotteryTableViewCell: UITableViewCell {
    
    static let identifier = "LotteryTableViewCell"
    
    var delegate:LotteryTableViewCellDelegate?

    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemNameLabel: CustomLabel!
        
    @IBOutlet weak var pointLabel: UILabel!
    
    @IBOutlet weak var duringTimeLabel: CustomLabel!
    
    @IBOutlet weak var drawTimeLabel: CustomLabel!
    
    @IBOutlet weak var drawPeopleLabel:CustomLabel!
    
    @IBOutlet weak var hideView:UIView!
    
    @IBOutlet weak var hideViewImageView: UIImageView?
    
    @IBOutlet weak var hideViewTitleLabel:CustomLabel!
    
    @IBOutlet weak var hideViewDrawTimeLabel:CustomLabel!
    
    @IBOutlet weak var verityTextField:UITextField!
    
    @IBOutlet weak var verityLineButton:CustomButton!
    
    private var category: CouponsCategory?
    
    private var createTime:String?
        
    private var url:String?
    
    private var isUnlocked:Bool? = nil
    {
        willSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                hideView.isHidden = true
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
    
    private var lotteryDrawDate:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    drawTimeLabel.text = "duringDate".localized + ":" + newValue
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
    
    private var purchaserCount:Int? 
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    drawPeopleLabel.text = "\("join".localized) \(newValue)"
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let color = #colorLiteral(red: 0.5607843137, green: 0.7411764706, blue: 0.6705882353, alpha: 1)
        setPlaceholderColor(color)
        addUnderlineToVerityTextField(color)
        addGesture()
        verityTextField.delegate = self
        verityLineButton.layer.cornerRadius = verityLineButton.bounds.height / 2
    }
    
    private func addGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideImageViewEvent(_:)))
        hideViewImageView?.addGestureRecognizer(tap)
    }
    
    @objc private func hideImageViewEvent(_ tap:UITapGestureRecognizer) {
        if let url = url {
            delegate?.lotteryHideImageEvent(url)
        }
    }
    
    @IBAction func buttonEvent(_ sender: UIButton) {
        guard let verityTextFieldText = verityTextField.text, let createTime = createTime, let itemName = itemName, let category = category else { return }
        delegate?.lotteryButtonEvent(itemName, category.rawValue, verityTextFieldText, createTime)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
    
    func setCell(_ lotteryInfo:LotteryInfo) {
        DispatchQueue(label: "com.geek-is-stupid.queue.configure-cell").async {
            
            self.isUnlocked = lotteryInfo.isUnlocked
            
            self.category = lotteryInfo.category

            if let createTime = lotteryInfo.createTime {
                self.createTime = createTime
            }
            
            if let url = lotteryInfo.url {
                self.url = url
            }
            
            if let productImageURLStr = lotteryInfo.productImage, let productImageURL = URL(string: productImageURLStr) {
                self.imageURL = productImageURL
            }
            
            if let itemName = lotteryInfo.itemName {
                self.itemName = itemName
            }
            
            var startTime:String?
            var endTime:String?
            if let eventStartTime = lotteryInfo.eventStartTime {
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
                let duringTimeText =  "activityTime".localized + ":" + startTime + "~" + endTime
                self.duringTime = duringTimeText
            }
            
            if let drawDate = lotteryInfo.drawDate {
                self.lotteryDrawDate = changeFormat(drawDate)
            }
            
            if let infoPoint = lotteryInfo.point {
                self.point = String(infoPoint)
            }
            
            if let purchaserCount = lotteryInfo.purchaserCount {
                self.purchaserCount = purchaserCount
            }
        }
    }
}


extension LotteryTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == verityTextField else { return true }
        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return true }
        let updated = currentText.replacingCharacters(in: textRange, with: string)
        return updated.count <= 6
    }
}
