//
//  CommonPronblemVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class CommonPronblemVC: CustomVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "常見問題說明"
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
