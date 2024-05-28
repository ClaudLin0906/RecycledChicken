//
//  CommodityAlertVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/5/28.
//

import UIKit
import M13Checkbox
class CommodityAlertVC: CustomVC {
    
    @IBOutlet weak var checkBox:M13Checkbox!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "帳號連結功能說明"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }
    
    private func UIInit() {
        checkBox.boxType = .square
        checkBox.stateChangeAnimation = .fill
    }
    
    @IBAction func confirm(_ sender:UIButton) {
        guard checkBox.checkState == .checked else {
            showAlert(VC: self, title: "需要同意")
            return
        }
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "Commodity", bundle: Bundle.main).instantiateViewController(identifier: "Commodity") as? CommodityVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func cancel(_ sender:UIButton) {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }

}
