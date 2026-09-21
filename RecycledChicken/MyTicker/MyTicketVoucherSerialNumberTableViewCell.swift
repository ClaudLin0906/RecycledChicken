//
//  MyTicketVoucherSerialNumberTableViewCell.swift
//  RecycledChicken
//
//  Created by Claud on 2024/3/14.
//

import UIKit
import Kingfisher

protocol MyTicketVoucherSerialNumberTableViewCellDelegate {
    func button(_ sender: UIButton, info: MyTickertCouponsInfo)
    func copyPassword(_ password: String)
}

class MyTicketVoucherSerialNumberTableViewCell: UITableViewCell {
    
    static let identifier = "MyTicketVoucherSerialNumberTableViewCell"
    
    var delegate: MyTicketVoucherSerialNumberTableViewCellDelegate?
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemNameLabel: CustomLabel!
    
    @IBOutlet weak var duringTimeLabel: CustomLabel!
    
    @IBOutlet weak var instructionLabel: CustomLabel!
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var serialNumberLabel: CustomLabel!
    
    @IBOutlet weak var noCompleteStackView:UIStackView!
    
    @IBOutlet weak var contentGetureView:UIView!
    
    @IBOutlet weak var redeemedView:RedeemedView!
    
    private var info:MyTickertCouponsInfo?
    
    private var imageURL:URL?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    itemImageView.kf.setImage(with: newValue)
                    redeemedView.setImage(imageURL?.absoluteString ?? "")
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
                    let displayName = convertCouponName(newValue)
                    itemNameLabel.text = displayName
                    redeemedView.setCompleteItemNameLabel(displayName)
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
                    duringTimeLabel.text = "使用期限至 \(newValue)"
                    redeemedView.setCompleteDuringTimeLabel(extractEndDate(newValue))
                }
            }
        }
    }
    
    private var serialNumber:String?
    {
        willSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let newValue = newValue {
                    self.serialNumberLabel.text = "使用序號\(newValue)"
                    self.serialNumberLabel.isHidden = false
                } else {
                    self.serialNumberLabel.text = nil
                    self.serialNumberLabel.isHidden = true
                }
            }
        }
    }
    
    private var instruction:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    instructionLabel.text = newValue
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        contentGetureView.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func longPressAction(_ longPress: UILongPressGestureRecognizer) {
        guard longPress.state == .began, let code = info?.code else { return }
        delegate?.copyPassword(code)
    }
    
    @IBAction func btnOnClick(_ sender: UIButton) {
        guard let info = info else { return }
        delegate?.button(sender, info: info)
    }
    
    private func extractEndDate(_ value: String) -> String {
        let parts = value.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: CharacterSet(charactersIn: "-－—–"))
        return parts.last?.trimmingCharacters(in: .whitespacesAndNewlines) ?? value
    }
    
    func compeletedAction() {
        let color = #colorLiteral(red: 0.7294117647, green: 0.3607843137, blue: 0.1490196078, alpha: 1)
        itemImageView.backgroundColor = color
        noCompleteStackView.isHidden = true
        redeemedView.isHidden = false
        contentGetureView.backgroundColor = color
    }
    
    func noCompeletedAction() {
        let color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        itemImageView.backgroundColor = color
        noCompleteStackView.isHidden = false
        redeemedView.isHidden = true
        contentGetureView.backgroundColor = color
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        itemNameLabel.text = nil
        duringTimeLabel.text = nil
        instructionLabel.text = nil
        actionButton.isHidden = true
        serialNumberLabel.text = nil
        serialNumberLabel.isHidden = true
    }
    
    func setCell(_ info:MyTickertCouponsInfo) {
        DispatchQueue(label: "com.geek-is-stupid.queue.configure-cell").async { [weak self] in
            guard let self = self else { return }
            self.info = info
            if let pictureStr = info.picture, let pictureURL = URL(string: pictureStr) {
                imageURL = pictureURL
            }
            if let name = info.name {
                itemName = name
            }
            if let expire = info.expire {
                duringTime = "\(expire)"
            }
            if let instruction = info.instruction {
                self.instruction = instruction
            }
            let needsActionButton = info.redeemType != nil || !(info.partner ?? "").isEmpty
            DispatchQueue.main.async {
                self.actionButton.isHidden = !needsActionButton
            }
            if !needsActionButton, let code = info.code {
                serialNumber = code
            } else {
                serialNumber = nil
            }
        }
    }

}
