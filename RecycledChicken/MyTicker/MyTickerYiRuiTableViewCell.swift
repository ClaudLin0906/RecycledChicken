//
//  MyTickerYiRuiTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2025/12/17.
//

import UIKit

class MyTickerYiRuiTableViewCell: UITableViewCell {
    
    static let identifier = "MyTickerYiRuiTableViewCell"
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemNameLabel: CustomLabel!
    
    @IBOutlet weak var duringTimeLabel: CustomLabel!
    
    @IBOutlet weak var passwordLabel: CustomLabel!
    
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
    
    private var password:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    passwordLabel.text = newValue
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
        passwordLabel.text = nil
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
            if let pwd = info.pwd {
                let fullText = "兌換密碼 \(pwd)"
                self.setUnderlineText(fullText: fullText, underlineText: pwd)
            }
        }
    }
    
    private func setUnderlineText(fullText: String, underlineText: String) {
        let attributedString = NSMutableAttributedString(string: fullText)
        let underlineRange = (fullText as NSString).range(of: underlineText)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: underlineRange)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.passwordLabel.attributedText = attributedString
        }
    }

}
