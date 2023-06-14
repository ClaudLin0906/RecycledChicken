//
//  DeleteAccountAlertView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/15.
//

import UIKit

class DeleteAccountAlertView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var passwordTextField:UITextField!

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
    
    @IBAction func cancel(_ sender:UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func confirm(_ sender:UIButton) {
        var alertMsg = ""
        let phone = passwordTextField.text
        
        if phone == "" {
            alertMsg += "密碼不能為空"
        }
        alertMsg = removeWhitespace(from: alertMsg)
        
        guard alertMsg == "" else {
            if let VC = self.parentViewController {
                showAlert(VC: VC, title: nil, message: alertMsg, alertAction: nil)
            }
            return
        }
        self.removeFromSuperview()
    }

}
