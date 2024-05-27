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
            if let pictureStr = info.picture, let pictureURL = URL(string: pictureStr) {
                self.imageURL = pictureURL
            }
            if let name = info.name {
                self.itemName = name
            }
            if let expire = info.expire {
                self.duringTime = "使用期限至 \(expire)"
            }
        }
    }

}
