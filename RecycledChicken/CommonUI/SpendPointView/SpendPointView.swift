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
    
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var itemAmount:UILabel!
    
    @IBOutlet weak var needPoint:UILabel!
    
    private var amount:Int = 0
    {
        willSet{
            DispatchQueue.main.async { [self] in
                itemAmount.text = String(newValue)
                let needPointInt = (lotteryInfo?.itemPrice ?? 0) * newValue
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
            tableView.reloadData()
        }
    }
    
    var commodityVoucherInfo:CommodityVoucherInfo?
    {
        willSet{
            type = .CommodityVoucher
            tableView.reloadData()
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
    
    private func customInit(){
        loadNibContent()
        amount = 1
        itemAmount.text = String(amount)
        tableView.setSeparatorLocation()
        tableView.register(UINib(nibName: "LotteryItemTableViewCell", bundle: nil), forCellReuseIdentifier: "LotteryItemTableViewCell")
        
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
    
    @IBAction func btnAction(_sender:UIButton) {
        
        guard amount > 0 else {
            delegate?.alertMessage("數量要大於0")
            return
        }
        
        guard let profileInfo = CurrentUserInfo.shared.currentProfileInfo, let lotteryInfo = lotteryInfo, profileInfo.point >= (lotteryInfo.itemPrice * amount) else {
            delegate?.alertMessage("點數不足")
            return
        }
        
        let spendPointInfo = SpendPointInfo(lotteryItemName: lotteryInfo.itemName, lotteryItemCreateTime: lotteryInfo.createTime, count: amount, totalPoint: String(lotteryInfo.itemPrice * amount))
        delegate?.btnAction(_sender, info: spendPointInfo)
    }

}

extension SpendPointView:UITableViewDelegate {
    
}


extension SpendPointView:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LotteryItemTableViewCell", for: indexPath) as! LotteryItemTableViewCell
        switch type {
        case .Lottery:
            if let lotteryInfo = lotteryInfo {
                cell.setCell(lotteryInfo: lotteryInfo)
            }
        case .CommodityVoucher:
            if let commodityVoucherInfo = commodityVoucherInfo {
                cell.setCell(commodityVoucherInfo: commodityVoucherInfo)
            }
        }

        return cell

    }
    
    
}