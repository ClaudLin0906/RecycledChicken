//
//  ForgetPasswordVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/13.
//

import UIKit

class ForgetPasswordVC: CustomLoginVC {
    
    @IBOutlet weak var phoneTextfield:UITextField!
    
    private var phone:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendSMS(_ sender:UIButton){
        var alertMsg = ""
        
        phone = phoneTextfield.text
        
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
        goToVerificationCode()
    }
    
    @IBAction func goToConfirmForgetPassword(_ sender:UIButton){
        var alertMsg = ""
        
        phone = phoneTextfield.text
        
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
        self.dismiss(animated: true) {
            if let VC = UIStoryboard(name: "ConfirmPassword", bundle: nil).instantiateViewController(withIdentifier: "ConfirmPassword") as? ConfirmPasswordVC, let topVC = getTopController() {
                VC.modalPresentationStyle = .fullScreen
                VC.phone = self.phone ?? ""
                topVC.present(VC, animated: true)
            }
        }
    }
    
    private func goToVerificationCode(){
        self.dismiss(animated: true) {
            if let VC = UIStoryboard(name: "VerificationCode", bundle: nil).instantiateViewController(withIdentifier: "VerificationCode") as? VerificationCodeVC, let topVC = getTopController() {
                VC.currentType = .forgetPassword
                VC.modalPresentationStyle = .fullScreen
                VC.phone = self.phone ?? ""
                topVC.present(VC, animated: true)
            }
        }
    }
    
    private func goToConfirmPassword(phone:String){
        self.dismiss(animated: true) {
            if let VC = UIStoryboard(name: "ConfirmPassword", bundle: nil).instantiateViewController(withIdentifier: "ConfirmPassword") as? ConfirmPasswordVC, let topVC = getTopController() {
                VC.modalPresentationStyle = .fullScreen
                topVC.present(VC, animated: true)
            }
        }
    }

}
