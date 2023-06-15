//
//  PrivacyPolicyVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class PrivacyPolicyVC: CustomVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "服務條款與隱私政策"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }

}
