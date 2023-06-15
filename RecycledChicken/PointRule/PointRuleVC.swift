//
//  PointRuleVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

class PointRuleVC: CustomVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "點數機制"
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
