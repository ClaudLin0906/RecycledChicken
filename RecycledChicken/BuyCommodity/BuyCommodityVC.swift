//
//  BuyCommodityVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

class BuyCommodityVC: CustomVC {
    
    @IBOutlet weak var spendPointView:SpendPointView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "購買商品序號"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        spendPointView.setConfirmBtnTitle("確認兌換")
        spendPointView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }


}

extension BuyCommodityVC: SpendPointViewDelegate {
    
    func alertMessage(_ message: String) {
        showAlert(VC: self, title: message, message: nil, alertAction: nil)
    }
    
    
    func btnAction(_ sender: UIButton, info: SpendPointInfo) {
        let spendPointAlertView = SpendPointAlertView(frame: UIScreen.main.bounds)
        spendPointAlertView.delegate = self
        keyWindow?.addSubview(spendPointAlertView)
    }
    
}

extension BuyCommodityVC: SpendPointAlertViewDelegate {
    
    func confirm(_ sender: UIButton, info: SpendPointInfo) {
        let completeTaskAlertView = SpendPointCompleteAlertView(frame: UIScreen.main.bounds)
        fadeInOutAni(showView: completeTaskAlertView, finishAction: nil)
    }
    
}

