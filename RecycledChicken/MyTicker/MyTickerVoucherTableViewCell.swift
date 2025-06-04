//
//  MyTickerVoucherTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/28.
//

import UIKit
import Kingfisher
class MyTickerVoucherTableViewCell: UITableViewCell {
    
    static let identifier = "MyTickerVoucherTableViewCell"
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemNameLabel: CustomLabel!
    
    @IBOutlet weak var duringTimeLabel: CustomLabel!
    
    @IBOutlet weak var instructionLabel: CustomLabel!
        
    private var info:MyTickertCouponsInfo?
    
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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnOnClick(_ sender:UIButton) {
        guard let info = info, let link = info.link, let url = URL(string: link) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        itemNameLabel.text = nil
        duringTimeLabel.text = nil
        instructionLabel.text = nil
        imageURL = nil
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
            if let expire = info.expire {
                self.duringTime = "使用期限至 \(expire)"
            }
            if let instruction = info.instruction {
                self.instruction = instruction
            }
        }
    }

}
