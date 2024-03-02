//
//  ProductAlertVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/3/2.
//

import UIKit
import M13Checkbox

class ProductAlertVC: CustomVC {
    
    @IBOutlet weak var checkBox:M13Checkbox!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "帳號連結功能說明"
        // Do any additional setup after loading the view.
        UIInit()
    }
    
    private func UIInit() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }
    
    @IBAction func confirm(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "Product", bundle: Bundle.main).instantiateViewController(identifier: "Product") as? ProductVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }

}
