//
//  ConfirmPasswordVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/13.
//

import UIKit

class ConfirmPasswordVC: CustomLoginVC {
    
    var phone:String = ""
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func confirm(_ sender:UIButton) {
        var alertMsg = ""
        let newPWD = newPasswordTextField.text
        let confirmPWd = confirmNewPasswordTextField.text
        
        if newPWD == "" {
            alertMsg += "密碼不能為空"
        }
        
        if confirmPWd == "" {
            alertMsg += "\n確認不能為空"
        }
        
        if newPWD != confirmPWd{
            alertMsg += "\n密碼不一致"
        }
        
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
            return
        }
        changePassword()
    }
    
    
    private func changePassword(){
        
    }
}
