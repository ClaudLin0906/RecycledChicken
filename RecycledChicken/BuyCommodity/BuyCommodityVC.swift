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
        title = "購 買 商 品 序 號"
        setDefaultNavigationBackBtn2()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        spendPointView.setConfirmBtnTitle("確認兌換")
        spendPointView.delegate = self
    }

}

extension BuyCommodityVC: SpendPointViewDelegate {
    
    func btnAction(_ sender: UIButton) {
        let spendPointAlertView = SpendPointAlertView(frame: UIScreen.main.bounds)
        spendPointAlertView.delegate = self
        keyWindow?.addSubview(spendPointAlertView)
    }

}

extension BuyCommodityVC: SpendPointAlertViewDelegate {
    
    func confirm(_ sender: UIButton) {
        let completeTaskAlertView = SpendPointCompleteAlertView(frame: UIScreen.main.bounds)
        fadeInOutAni(showView: completeTaskAlertView)
    }
    
}

