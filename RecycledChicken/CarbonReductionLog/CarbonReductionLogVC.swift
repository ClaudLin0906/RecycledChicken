//
//  CarbonReductionLogVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/8.
//

import UIKit

class CarbonReductionLogVC: CustomVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "減碳歷程"
        UIInit()
        setDefaultNavigationBackBtn()
    }

    private func UIInit() {
        view.backgroundColor = CommonColor.shared.color1
    }
}
