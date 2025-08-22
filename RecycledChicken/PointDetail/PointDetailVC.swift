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
        userGuideAlertCell.setCell("碳碳金點數提醒與使用說明","\n•  碳碳金是你用心回收和參與任務換來的獎勵，讓它們發揮價值吧！\n\n•  點數會即時或最晚7天內自動入帳會員帳戶。\n\n•  點數有效期為12個月，記得及時使用，讓每分努力都有回報！\n\n•  你可以隨時查詢近12個月內的點數紀錄，掌握自己的積分動態。\n\n小提醒\n\n•  系統每年會進行定期維護，維護期間可能暫時無法查看或使用點數，敬請見諒！\n\n•  發現異常使用行為（如重複投遞），平台會取消點數並保留停權權利。")
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
    
    @IBAction func tapDetail(_ tap:UITapGestureRecognizer) {
        if let url = URL(string:RedirectURL.pointDetail) {
            UIApplication.shared.open(url)
        }
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
