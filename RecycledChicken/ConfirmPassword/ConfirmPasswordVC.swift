//
//  ConfirmPasswordVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/13.
//

import UIKit

class ConfirmPasswordVC: CustomLoginVC {
    
    var phone = ""
    
    private var newPassword = ""
    
    var info:forgetPasswordInfo?
    
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
        }else if !validatePassword(text: newPWD!) {
            alertMsg += "密碼格式不對"
        }
        
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
            return
        }
        
        if confirmPWd == "" {
            alertMsg += "確認不能為空"
        }
        
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
            return
        }
        
        if newPWD != confirmPWd{
            alertMsg += "密碼不一致"
        }
        
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
            return
        }
        newPassword = newPWD ?? ""
        goToVerificationCode()
    }
    
    private func goToVerificationCode(){
        self.dismiss(animated: true) { [self] in
            if let VC = UIStoryboard(name: "VerificationCode", bundle: nil).instantiateViewController(withIdentifier: "VerificationCode") as? VerificationCodeVC, let topVC = getTopController() {
                VC.currentType = .forgetPassword
                VC.modalPresentationStyle = .fullScreen
                info = forgetPasswordInfo(userPhoneNumber: phone , newPassword: newPassword, smsCode: "")
                VC.info = info
                topVC.present(VC, animated: true)
            }
        }
    }
}
