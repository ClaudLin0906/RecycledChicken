//
//  ConfirmPasswordVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/13.
//

import UIKit

class ConfirmPasswordVC: CustomLoginVC {
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    
    @IBOutlet weak var goHomeBtn:CustomButton!
    
    @IBOutlet weak var erroMSGLabel:UILabel!
        
    var phone = ""
    
    private var newPassword = ""
    
    var info:forgetPasswordInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UIInit()
    }
    
    private func UIInit(){
        goHomeBtn.addTarget(self, action: #selector(goSignLoginVC(_:)), for: .touchUpInside)
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
            showAlert(VC: self, title: nil, message: alertMsg)
            return
        }
        
        if confirmPWd == "" {
            alertMsg += "確認不能為空"
        }
        
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            showAlert(VC: self, title: nil, message: alertMsg)
            return
        }
        
        if newPWD != confirmPWd{
            alertMsg += "密碼不一致"
        }
        
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            erroMSGLabel.isHidden = false
            erroMSGLabel.text = alertMsg
            return
        }
        newPassword = newPWD ?? ""
        goToVerificationCode()
    }
    
    private func goToVerificationCode(){
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
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
