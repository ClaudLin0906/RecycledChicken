//
//  PointDetailVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2025/7/4.
//

import UIKit

class PointDetailVC: CustomVC {
    
    @IBOutlet weak var myPoint:UILabel!
    
    @IBOutlet weak var userGuideAlertCell:PointDetailAlertCell!
    
    @IBOutlet weak var pointDetailAlertCell:PointDetailAlertCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "pointDetail".localized
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        setPointText()
        userGuideAlertCell.setCell("使用說明", "")
        pointDetailAlertCell.setCell("注意事項", "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }
    
    private func setPointText() {
        if let point = CurrentUserInfo.shared.currentProfileNewInfo?.point {
            self.myPoint.text = String(point)
        }
    }
    
}
