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
