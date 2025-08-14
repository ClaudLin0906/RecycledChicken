//
//  PartnerMerchantsTableViewTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/28.
//

import UIKit

protocol PartnerMerchantsTableViewTableViewCellDelegate {
    func partnerMerchantsHideImageEvent(_ link:String)
    func partnerMerchantsHideButtonEvent(_ name:String, _ category:String, _ veriftyCode:String, _ createTime:String)
}

class PartnerMerchantsTableViewTableViewCell: UITableViewCell {
    
    static let identifier = "PartnerMerchantsTableViewTableViewCell"
    
    var delegate:PartnerMerchantsTableViewTableViewCellDelegate?
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemNameLabel: CustomLabel!
        
    @IBOutlet weak var pointLabel: UILabel!
    
    @IBOutlet weak var duringTimeLabel: CustomLabel!
    
    @IBOutlet weak var drawTimeLabel: CustomLabel!
    
    @IBOutlet weak var drawPeopleLabel:CustomLabel!
    
    @IBOutlet weak var remainingQuantityLabel:CustomLabel!
    
    @IBOutlet weak var hideView:UIView!
    
    @IBOutlet weak var hideViewImageView: UIImageView?
    
    @IBOutlet weak var hideViewTitleLabel:CustomLabel!
    
    @IBOutlet weak var hideViewDrawTimeLabel:CustomLabel!
    
    @IBOutlet weak var verityTextField:UITextField!
    
    @IBOutlet weak var verityLineButton:CustomButton!
    
    private var category: CouponsCategory?
    
    private var createTime:String?
    
    private var link:String?
    
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
                    drawTimeLabel.text = "timeOfUse".localized + ":" + newValue
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
    private var remainingQuantity:Int?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    remainingQuantityLabel.text = "剩餘數量 \(String(newValue))"
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func addGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideImageViewEvent(_:)))
        hideViewImageView?.addGestureRecognizer(tap)
    }
    
    @objc private func hideImageViewEvent(_ tap:UITapGestureRecognizer) {
        if let link = link {
            delegate?.partnerMerchantsHideImageEvent(link)
        }
    }
    
    @IBAction func buttonEvent(_ sender: UIButton) {
        guard let verityTextFieldText = verityTextField.text, let createTime = createTime, let itemName = itemName, let category = category else { return }
        delegate?.partnerMerchantsHideButtonEvent(itemName, category.rawValue, verityTextFieldText, createTime)
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
            
            if let category = commodityVoucherInfo.category {
                self.category = category
            }
            
            if let createTime = commodityVoucherInfo.createTime {
                self.createTime = createTime
            }
            
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
                }else{
                    endTime = eventEndTime
                }
            }
            
            if let startTime = startTime, let endTime = endTime {
                self.duringTime = "activityTime".localized + ":" + startTime + "~" + endTime
            }
            
            if let drawDate = commodityVoucherInfo.expire {
                self.lotteryDrawDate = drawDate
            }
            
            if let infoPoint = commodityVoucherInfo.points {
                self.point = String(infoPoint)
            }
            
            if let remainingQuantity = commodityVoucherInfo.remainingQuantity {
                self.remainingQuantity = remainingQuantity
            }
        }
    }
}

extension PartnerMerchantsTableViewTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == verityTextField else { return true }
        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return true }
        let updated = currentText.replacingCharacters(in: textRange, with: string)
        return updated.count <= 6
    }
}
