//
//  BuyLotteryVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

class BuyLotteryVC: CustomVC {
    
    @IBOutlet weak var spendPointView:SpendPointView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "購 買 抽 獎 序 號"
        setDefaultNavigationBackBtn2()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        spendPointView.delegate = self
    }

}

extension BuyLotteryVC: SpendPointViewDelegate {
    
    func btnAction(_ sender: UIButton) {
        let spendPointAlertView = SpendPointAlertView(frame: view.frame)
        spendPointAlertView.delegate = self
        keyWindow?.addSubview(spendPointAlertView)
    }

}

extension BuyLotteryVC: SpendPointAlertViewDelegate {
    
    func confirm(_ sender: UIButton) {
        let completeTaskAlertView = SpendPointCompleteAlertView(frame: view.frame)
        fadeInOutAni(showView: completeTaskAlertView)
    }
    
}
