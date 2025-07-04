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
    
    @IBOutlet weak var thisYearAboutToExpireView:PointsAboutToExpireView!
    
    @IBOutlet weak var nextYearAboutToExpireView:PointsAboutToExpireView!
    
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
        thisYearAboutToExpireView.set("即將到期點數", point: getExpirePoint())
        nextYearAboutToExpireView.set("隔年度到期點數", 1 , point: getExpirePointNextYear())
    }
    
    private func getExpirePoint() -> String {
        guard let expirePoint = CurrentUserInfo.shared.currentProfileNewInfo?.expirePoint else {
            return "0"
        }
        return String(expirePoint)
    }
    
    private func getExpirePointNextYear() -> String {
        guard let expirePoint = CurrentUserInfo.shared.currentProfileNewInfo?.expirePoint, let point = CurrentUserInfo.shared.currentProfileNewInfo?.point, (point - expirePoint) > 0 else {
            return "0"
        }
        return String(point - expirePoint)
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
