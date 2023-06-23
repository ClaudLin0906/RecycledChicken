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
    
    @IBOutlet weak var myPoint:UILabel!

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let point = CurrentUserInfo.shared.currentProfileInfo?.point {
            myPoint.text = String(point)
        }
    }
    
    @IBAction func goToCommodityVoucher(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "CommodityVoucher", bundle: Bundle.main).instantiateViewController(identifier: "CommodityVoucher") as? CommodityVoucherVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToLottery(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "Lottery", bundle: Bundle.main).instantiateViewController(identifier: "Lottery") as? LotteryVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToPointRule(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "PointRule", bundle: Bundle.main).instantiateViewController(identifier: "PointRule") as? PointRuleVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToMyTicker(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "MyTicker", bundle: Bundle.main).instantiateViewController(identifier: "MyTicker") as? MyTickerVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    
}
