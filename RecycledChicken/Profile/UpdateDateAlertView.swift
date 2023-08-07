//
//  UpdateDateAlertView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/13.
//

import UIKit

class UpdateDateAlertView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var updateLabel:UILabel!
    
    var VC:ProfileVC?
    
    var userInfo:ProfileInfo?
    {
        willSet{
            if let newValue = newValue {
                updateLabel.text = "確定是要更改為 \(newValue.userBirth)嗎?"
                updateLabel.font = updateLabel.font.withSize(14)
            }
        }
    }
    
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
    
    @IBAction func confirm(_ sender:UIButton) {
        if let VC = VC, let userInfo = userInfo {
            VC.updateUserInfo(userInfo: userInfo)
            remove()
        }
    }
    
    @IBAction func cancel(_ sender:UIButton) {
        remove()
    }
    
    private func remove(){
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
    
}
