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
        title = "購買抽獎序號"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        spendPointView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
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
