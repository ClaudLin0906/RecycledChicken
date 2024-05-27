//
//  SpendPointView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit
import Kingfisher
protocol SpendPointViewDelegate{
    func btnAction(_ sender:UIButton, info:SpendPointInfo)
    func alertMessage(_ message:String)
}

class SpendPointView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var confirm:UIButton!
        
    @IBOutlet weak var itemAmount:UILabel!
    
    @IBOutlet weak var needPoint:UILabel!
    
    @IBOutlet weak var itemImageView:UIImageView!
    
    @IBOutlet weak var itemNameLabel:CustomLabel!
    
    @IBOutlet weak var itemPriceLabel:UILabel!
    
    @IBOutlet weak var drawTimeLabel:CustomLabel!
    
    @IBOutlet weak var itemDescriptionTextView:UITextView!
        
    private var amount:Int = 0
    {
        willSet{
            DispatchQueue.main.async { [self] in
                itemAmount.text = String(newValue)
                var needPointInt:Int = 0
                switch type {
                case .CommodityVoucher:
                    needPointInt = (commodityVoucherInfo?.points ?? 0) * newValue
                case .Lottery:
                    needPointInt = (lotteryInfo?.point ?? 0) * newValue
                }
                needPoint.text = String(needPointInt)
            }
        }
    }
    
    private var subtract:Int = 1
    
    private var add:Int = 1
    
    var delegate:SpendPointViewDelegate?
    
    var lotteryInfo:LotteryInfo?
    {
        willSet{
            type = .Lottery
            setInfo()
        }
    }
    
    var commodityVoucherInfo:CommodityVoucherInfo?
    {
        willSet{
            type = .CommodityVoucher
            setInfo()
        }
    }
    
    private var type:SpendPointType = .Lottery

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setInfo()
    }
    
    private func setInfo() {
        switch type {
        case .CommodityVoucher:
            guard let commodityVoucherInfo = commodityVoucherInfo else { return }
            
            if let picture = commodityVoucherInfo.picture, let imageURL = URL(string: picture) {
                itemImageView.kf.setImage(with: imageURL)
            }
            
            if let name = commodityVoucherInfo.name {
                itemNameLabel.text = name
            }
            
            if let points = commodityVoucherInfo.points {
                itemPriceLabel.text = String(points)
            }
            
            if let start = commodityVoucherInfo.start, let end = commodityVoucherInfo.end {
                drawTimeLabel.text = "validDate".localized + ":" + start + "~" + end
            }
            
            if let description = commodityVoucherInfo.description {
                itemDescriptionTextView.text = description
            }
        case .Lottery:
            guard let lotteryInfo = lotteryInfo else { return }
            
            if let productImage = lotteryInfo.productImage, let imageURL = URL(string: productImage) {
                itemImageView.kf.setImage(with: imageURL)
            }
            
            if let itemName = lotteryInfo.itemName {
                itemNameLabel.text = itemName
            }
            
            if let point = lotteryInfo.point {
                itemPriceLabel.text = String(point)
            }
            
            if let drawDate = lotteryInfo.drawDate {
                drawTimeLabel.text = "duringDate".localized + ":" + drawDate
            }
            
            if let description = lotteryInfo.description {
                itemDescriptionTextView.text = description
            }
        }

    }
    
    private func customInit(){
        loadNibContent()
        amount = 1
//        tableView.setSeparatorLocation()
//        tableView.register(UINib(nibName: "LotteryItemTableViewCell", bundle: nil), forCellReuseIdentifier: "LotteryItemTableViewCell")
    }
    
    @IBAction func plusBtn(_ sender:UIButton){
        amount += add
        if amount > 10 {
            amount = 10
        }
    }
    
    @IBAction func minusBtn(_ sender:UIButton){
        amount -= subtract
        if amount < 0 {
            amount = 0
        }
    }
    
    func setConfirmBtnTitle(_ title:String){
        confirm.setTitle(title, for: .normal)
    }
    
    private func handleInfo(_ sender:UIButton, _ itemName:String, _ itemCreateTime:String, _ totalPoint:String) {
        let spendPointInfo = SpendPointInfo(name: itemName, createTime: itemCreateTime, count: amount, totalPoint: totalPoint)
        delegate?.btnAction(sender, info: spendPointInfo)
    }
    
    @IBAction func btnAction(_ sender:UIButton) {
        
        guard amount > 0 else {
            delegate?.alertMessage("數量要大於0")
            return
        }
        guard let profileInfo = CurrentUserInfo.shared.currentProfileNewInfo else { return }
        switch type {
        case .CommodityVoucher:
            guard let commodityVoucherInfo = commodityVoucherInfo, let profileInfoPoint = profileInfo.point, let point = commodityVoucherInfo.points else { return }
            if profileInfoPoint < (point * amount) {
                delegate?.alertMessage("點數不足")
            }
            if profileInfoPoint >= (point * amount), let createTime = commodityVoucherInfo.createTime  {
                handleInfo(sender, commodityVoucherInfo.name ?? "", createTime, String(point * amount))
            }
        case .Lottery:
            guard let lotteryInfo = lotteryInfo, let profileInfoPoint = profileInfo.point, let point = lotteryInfo.point else { return }
            if profileInfoPoint < (point * amount) {
                delegate?.alertMessage("點數不足")
            }
            if profileInfoPoint >= (point * amount), let createTime = lotteryInfo.createTime {
                handleInfo(sender, lotteryInfo.itemName ?? "", createTime, String(point * amount))
            }

        }
        
    }

}
