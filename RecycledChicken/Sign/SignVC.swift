//
//  SignVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/7.
//

import UIKit

class SignVC: CustomLoginVC {
    
    @IBOutlet weak var phoneTextfield:UITextField!
    
    @IBOutlet weak var passwordTextfield:UITextField!
    
    @IBOutlet weak var goHomeBtn:CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        goHomeBtn.addTarget(self, action: #selector(goSignLoginVC(_:)), for: .touchUpInside)
    }
    
    private func goToVerificationCode(phone:String, password:String ){
        self.dismiss(animated: true) {
            if let VC = UIStoryboard(name: "VerificationCode", bundle: nil).instantiateViewController(withIdentifier: "VerificationCode") as? VerificationCodeVC, let topVC = getTopController() {
                VC.currentType = .sign
                VC.modalPresentationStyle = .fullScreen
                VC.password = password
                VC.phone = phone
                topVC.present(VC, animated: true)
            }
        }
    }
    
    
    @IBAction func sendVerificationCode(_ sender:UIButton) {
        var alertMsg = ""
        let password = passwordTextfield.text
        let phone = phoneTextfield.text
        if phone == "" {
            alertMsg += "電話不能為空"
        } else if !validateCellPhone(text: phone!) {
            alertMsg += "電話格式不對"
        }
        
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
            return
        }
        
        if password == "" {
            alertMsg += "密碼不能為空"
        }else if !validatePassword(text: password!) {
            alertMsg += "密碼格式不對"
        }
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
            return
        }
        goToVerificationCode(phone: phone!, password: password!)
    }

}
