//
//  PointVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class PointVC: CustomRootVC {
    
    @IBOutlet weak var ponitRuleBtn:UIButton!
    
    @IBOutlet weak var myTicker:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    

    private func UIInit(){
        ponitRuleBtn.layer.borderWidth = 1
        ponitRuleBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
        myTicker.layer.borderWidth = 1
        myTicker.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
    }

    @IBAction func goToLottery(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "Lottery", bundle: Bundle.main).instantiateViewController(identifier: "Lottery") as? LotteryVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToBuyLottery(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "BuyLottery", bundle: Bundle.main).instantiateViewController(identifier: "BuyLottery") as? BuyLotteryVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToBuyCommodity(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "BuyCommodity", bundle: Bundle.main).instantiateViewController(identifier: "BuyCommodity") as? BuyCommodityVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToPointRule(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "PointRule", bundle: Bundle.main).instantiateViewController(identifier: "PointRule") as? PointRuleVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    
}
