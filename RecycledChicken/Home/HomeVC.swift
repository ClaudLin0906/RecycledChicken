//
//  HomeVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import UIKit

class HomeVC: CustomRootVC {
    
    @IBOutlet weak var barcodeView:BarCodeView!
    
    @IBOutlet weak var carbonReductionLogBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        barcodeView.code = "0200 2344 1256"
    }
    
    private func UIInit(){
        carbonReductionLogBtn.layer.borderWidth = 1
        carbonReductionLogBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
    }
    
    @IBAction func goToCarbonReductionLog(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "CarbonReductionLog", bundle: Bundle.main).instantiateViewController(identifier: "CarbonReductionLog") as? CarbonReductionLogVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToProfile(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "Profile", bundle: Bundle.main).instantiateViewController(identifier: "Profile") as? ProfileVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }

}
