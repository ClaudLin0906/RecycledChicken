//
//  IllustratedContentVC.swift
//  RecycledChicken
//
//  Created by sj on 2024/5/21.
//

import UIKit

class IllustratedContentVC: CustomVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn()
    }
    
}
