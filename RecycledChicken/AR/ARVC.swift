//
//  ARVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

class ARVC: CustomRootVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        
    }
    
    @IBAction func goToProductDescription(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "ProductDescription", bundle: Bundle.main).instantiateViewController(identifier: "ProductDescription") as? ProductDescriptionVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }

}
