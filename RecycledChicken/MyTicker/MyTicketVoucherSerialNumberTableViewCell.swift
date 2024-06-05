//
//  MyTicketVoucherSerialNumberTableViewCell.swift
//  RecycledChicken
//
//  Created by Claud on 2024/3/14.
//

import UIKit
import Kingfisher
class MyTicketVoucherSerialNumberTableViewCell: UITableViewCell {
    
    static let identifier = "MyTicketVoucherSerialNumberTableViewCell"
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var serialNumberLabel:UILabel!
    
    @IBOutlet weak var itemNameLabel: CustomLabel!
    
    @IBOutlet weak var duringTimeLabel: CustomLabel!
    
    @IBOutlet weak var instructionLabel: CustomLabel!
    
    private var info:MyTickertCouponsInfo?
    
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
    
    private var serialNumber:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [self] in
                    serialNumberLabel.text = newValue
                }
            }
        }
    }
    
    private var instruction:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [self] in
                    instructionLabel.text = newValue
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
    
    func setCell(_ info:MyTickertCouponsInfo) {
        DispatchQueue(label: "com.geek-is-stupid.queue.configure-cell").async {
            self.info = info
            if let pictureStr = info.picture, let pictureURL = URL(string: pictureStr) {
                self.imageURL = pictureURL
            }
            if let name = info.name {
                self.itemName = name
            }
            if let code = info.code {
                self.serialNumber = code
            }
            if let expire = info.expire {
                self.duringTime = "使用期限至 \(expire)"
            }
            if let instruction = info.instruction {
                self.instruction = instruction
            }
        }
    }

}
