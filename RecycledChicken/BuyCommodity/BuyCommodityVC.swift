//
//  BuyCommodityVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

class BuyCommodityVC: CustomVC {
    
    @IBOutlet weak var spendPointView:SpendPointView!
    
    var commodityVoucherInfo:CommodityVoucherInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "兌換商品序號"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        spendPointView.setConfirmBtnTitle("確認購買")
        spendPointView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
        if let commodityVoucherInfo = commodityVoucherInfo{
            spendPointView.commodityVoucherInfo = commodityVoucherInfo
        }
    }


}

extension BuyCommodityVC: SpendPointViewDelegate {
    
    func alertMessage(_ message: String) {
        showAlert(VC: self, title: message, message: nil, alertAction: nil)
    }
    
    
    func btnAction(_ sender: UIButton, info: SpendPointInfo) {
        let spendPointAlertView = SpendPointAlertView(frame: UIScreen.main.bounds)
        spendPointAlertView.spendPointInfo = info
        spendPointAlertView.delegate = self
        keyWindow?.addSubview(spendPointAlertView)
    }
    
}

extension BuyCommodityVC: SpendPointAlertViewDelegate {
    
    func confirm(_ sender: UIButton, info: SpendPointInfo) {
        spendPointAction(info) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            getUserInfo(VC: self) {
                DispatchQueue.main.async { [self] in
                    let completeTaskAlertView = SpendPointCompleteAlertView(frame: UIScreen.main.bounds)
                    fadeInOutAni(showView: completeTaskAlertView, finishAction: nil)
                    if let navigationController = navigationController {
                        navigationController.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
}

