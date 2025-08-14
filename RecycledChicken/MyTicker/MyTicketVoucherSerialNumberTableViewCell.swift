//
//  MyTicketVoucherSerialNumberTableViewCell.swift
//  RecycledChicken
//
//  Created by Claud on 2024/3/14.
//

import UIKit
import Kingfisher

protocol MyTicketVoucherSerialNumberTableViewCellDelegate {
    func copySerialNumber(_ serialNumber:String)
}

class MyTicketVoucherSerialNumberTableViewCell: UITableViewCell {
    
    static let identifier = "MyTicketVoucherSerialNumberTableViewCell"
    
    var delegate:MyTicketVoucherSerialNumberTableViewCellDelegate?
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var serialNumberLabel:UILabel!
    
    @IBOutlet weak var itemNameLabel: CustomLabel!
    
    @IBOutlet weak var duringTimeLabel: CustomLabel!
    
    @IBOutlet weak var instructionLabel: CustomLabel!
    
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
                    itemNameLabel.text = newValue
                    redeemedView.setCompleteItemNameLabel(newValue)
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
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    serialNumberLabel.text = newValue
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
        contentView.addGestureRecognizer(longPressGesture)
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
    
    @objc private func longPressAction(_ longPress:UILongPressGestureRecognizer) {
        delegate?.copySerialNumber(serialNumberLabel.text ?? "")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        serialNumberLabel.text = nil
        itemNameLabel.text = nil
        duringTimeLabel.text = nil
        instructionLabel.text = nil
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
            if let code = info.code {
                serialNumber = code
            }
            if let expire = info.expire {
                duringTime = "\(expire)"
            }
            if let instruction = info.instruction {
                self.instruction = instruction
            }
        }
    }

}
