//
//  ForgetPasswordVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/13.
//

import UIKit

class ForgetPasswordVC: CustomLoginVC {
    
    @IBOutlet weak var phoneTextfield:UITextField!
    
    @IBOutlet weak var goHomeBtn:CustomButton!
    
    @IBOutlet weak var erroMSGLabel:UILabel!
    
    @IBOutlet weak var alertMSGLabel:UILabel!
    
    @IBOutlet weak var phoneWidth:NSLayoutConstraint!
    
    private var phone:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        goHomeBtn.addTarget(self, action: #selector(goSignLoginVC(_:)), for: .touchUpInside)
        if getLanguage() == .english {
            phoneWidth.constant = 50
        }
    }
    
    @IBAction func sendSMS(_ sender:UIButton){
        var alertMsg = ""
        
        phone = phoneTextfield.text
        
        if phone == "" {
            alertMsg += "phoneCannotBeEmpty".localized
        } else if !validateCellPhone(text: phone!) {
            alertMsg += "incorrectPhoneNumberFormat".localized
        }
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
//            showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
            showErrorMSG(alertMsg)
            return
        }
        goToVerificationCode()
    }
    
    private func showErrorMSG(_ errorMSG:String) {
        alertMSGLabel.isHidden = true
        erroMSGLabel.isHidden = false
        erroMSGLabel.text = errorMSG
    }
    
    @IBAction func goToConfirmForgetPassword(_ sender:UIButton){
        var alertMsg = ""
        phone = phoneTextfield.text
        if phone == "" {
            alertMsg += "phoneCannotBeEmpty".localized
        } else if !validateCellPhone(text: phone!) {
            alertMsg += "incorrectPhoneNumberFormat".localized
        }
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            showErrorMSG(alertMsg)
            return
        }
        let currentPhone = phone ?? ""
        dismissAndPresent(from: self, storyboard: "ConfirmPassword", identifier: "ConfirmPassword") { (vc: ConfirmPasswordVC) in
            vc.phone = currentPhone
        }
    }
    
    private func goToVerificationCode(){
        let currentPhone = phone ?? ""
        dismissAndPresent(from: self, storyboard: "VerificationCode", identifier: "VerificationCode") { (vc: VerificationCodeVC) in
            vc.currentType = .forgetPassword
            vc.phone = currentPhone
        }
    }
    
    private func goToConfirmPassword(phone: String){
        dismissAndPresent(from: self, storyboard: "ConfirmPassword", identifier: "ConfirmPassword")
    }

}
