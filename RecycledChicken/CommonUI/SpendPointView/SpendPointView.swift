//
//  SpendPointView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

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
        
    private var amount:Int = 0
    {
        willSet{
            DispatchQueue.main.async { [self] in
                itemAmount.text = String(newValue)
                var needPointInt:Int = 0
                switch type {
                case .CommodityVoucher:
                    needPointInt = (commodityVoucherInfo?.itemPrice ?? 0) * newValue
                case .Lottery:
                    break
//                    needPointInt = (lotteryInfo?.itemPrice ?? 0) * newValue
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
            if let commodityVoucherInfo = commodityVoucherInfo, let data = try? Data(contentsOf: URL(string: commodityVoucherInfo.picture)!), let image = UIImage(data: data) {
                let activityStartTimeDate = dateFromString(commodityVoucherInfo.activityStartTime)
                let activityEndTimeDate = dateFromString(commodityVoucherInfo.activityEndTime)
                let StartDate = getDates(i: 0, currentDate: activityStartTimeDate!).0
                let EndDate = getDates(i: 0, currentDate: activityEndTimeDate!).0
                itemImageView.image = image
                itemNameLabel.text = commodityVoucherInfo.itemName
                itemPriceLabel.text = String(commodityVoucherInfo.itemPrice)
                drawTimeLabel.text = "validDate".localized + ":" + StartDate + "~" + EndDate
            }
        case .Lottery:
            break
//            if let lotteryInfo = lotteryInfo, let data = try? Data(contentsOf: URL(string: lotteryInfo.picture)!), let image = UIImage(data: data){
//                itemImageView.image = image
//                itemNameLabel.text = lotteryInfo.itemName
//                itemPriceLabel.text = String(lotteryInfo.itemPrice)
//                drawTimeLabel.text = "duringDate".localized + ":" + lotteryInfo.lotteryDrawDate
//            }
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
        let spendPointInfo = SpendPointInfo(lotteryItemName: itemName, lotteryItemCreateTime: itemCreateTime, count: amount, totalPoint: totalPoint)
        delegate?.btnAction(sender, info: spendPointInfo)
    }
    
    @IBAction func btnAction(_ sender:UIButton) {
        
        guard amount > 0 else {
            delegate?.alertMessage("數量要大於0")
            return
        }
        guard let profileInfo = CurrentUserInfo.shared.currentProfileInfo else { return }
        switch type {
        case .CommodityVoucher:
            if let commodityVoucherInfo = commodityVoucherInfo {
                if profileInfo.point < (commodityVoucherInfo.itemPrice * amount) {
                    delegate?.alertMessage("點數不足")
                }
                if profileInfo.point >= (commodityVoucherInfo.itemPrice * amount) {
                    handleInfo(sender, commodityVoucherInfo.itemName, commodityVoucherInfo.createTime, String(commodityVoucherInfo.itemPrice * amount))
                }
            }
        case .Lottery:
            if let lotteryInfo = lotteryInfo {
//                if profileInfo.point < (lotteryInfo.itemPrice * amount) {
//                    delegate?.alertMessage("點數不足")
//                }
//                if profileInfo.point >= (lotteryInfo.itemPrice * amount) {
//                    handleInfo(sender, lotteryInfo.itemName, lotteryInfo.createTime, String(lotteryInfo.itemPrice * amount))
//                }
            }
        }
        
    }

}
