//
//  SpendPointAlertView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/13.
//

import UIKit

protocol SpendPointAlertViewDelegate {
    func confirm(_ sender:UIButton, info:SpendPointInfo)
}

class SpendPointAlertView: UIView, NibOwnerLoadable {
    
    var delegate:SpendPointAlertViewDelegate?
    
    var spendPointInfo:SpendPointInfo?
    
    @IBOutlet weak var spendPointLabel:CustomLabel!
    
    @IBOutlet weak var remainder:UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit(){
        loadNibContent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let spendPointInfo = spendPointInfo, let profile = CurrentUserInfo.shared.currentProfileNewInfo, let point = profile.point {
            spendPointLabel.text = "本次將使用點數\(spendPointInfo.totalPoint)點"
            let remainderInt = point - (Int(spendPointInfo.totalPoint) ?? 0)
            remainder.text = String(remainderInt)
        }
    }
    
    @IBAction func confirm(_ sender:UIButton) {
        if let info = spendPointInfo {
            delegate?.confirm(sender, info: info)
        }
        self.removeFromSuperview()
    }
    
    @IBAction func cancel(_ sender:UIButton) {
        self.removeFromSuperview()
    }
}
