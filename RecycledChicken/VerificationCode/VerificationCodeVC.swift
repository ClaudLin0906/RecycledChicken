//
//  VerificationCodeVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/7.
//

import UIKit
import Alamofire

class VerificationCodeVC: CustomLoginVC {
    
    @IBOutlet weak var firstTextField:UITextField!
    
    @IBOutlet weak var secondTextField:UITextField!
    
    @IBOutlet weak var thirdTextField:UITextField!
    
    @IBOutlet weak var fourthTextField:UITextField!
    
    var password:String = ""
    
    var phone:String = ""
    
    var currentType:VerificationCodeType?
    
    var info:forgetPasswordInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        sendSMS()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        
    }
    
    private func sendSMS(){
        switch currentType {
        case .forgetPassword:
            phone = info?.userPhoneNumber ?? ""
        default:
            break
        }
        
        let smsInfo = SMSInfo(userPhoneNumber: phone)
        let smsInfoDic = try? smsInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.smsCode, parameters: smsInfoDic) { (data, statusCode, errorMSG) in
            
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            
            if let data = data {
                let json = NetworkManager.shared.dataToDictionary(data: data)
                print(json)
            }
            
        }
    }
    
    @IBAction func reSendSMS(_ sender:UIButton) {
        sendSMS()
    }
    
    private func signUpAction(_ smsCode:String){
        guard smsCode.count == 4 else { return }
        let signUpInfo = SignUpInfo(userPhoneNumber: phone, userPassword: password, smsCode: smsCode)
        let signUpInfoDic = try? signUpInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.register, parameters: signUpInfoDic) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
        }
    }
    
    private func goToConfirmVC(){
        self.dismiss(animated: true) {
            if let VC = UIStoryboard(name: "ConfirmPassword", bundle: nil).instantiateViewController(withIdentifier: "ConfirmPassword") as? ConfirmPasswordVC, let topVC = getTopController() {
                VC.phone = self.phone
                VC.modalPresentationStyle = .fullScreen
                topVC.present(VC, animated: true)
            }
        }
    }
    
    private func forgetPasswordAction(_ smsCode:String){
        guard smsCode.count == 4, var info = info else { return }
        info.smsCode = smsCode
        let forgetPasswordInfo = info
        let forgetPasswordInfoDic = try? forgetPasswordInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.forgotPassword, parameters: forgetPasswordInfoDic) { (data, statusCode, errorMSG) in
            
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            
            if let data = data {
                let json = NetworkManager.shared.dataToDictionary(data: data)
                print(json)
                DispatchQueue.main.async { [self] in
                    let updatePasswordSuccessView = UpdatePasswordSuccessView(frame: self.view.frame)
                    fadeInOutAni(showView: updatePasswordSuccessView) {
                        self.goToLoginVC()
                    }
                }
            }
        }
    }
    
    private func goToLoginVC(){
        self.dismiss(animated: false) {
            if let VC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login") as? LoginVC, let topVC = getTopController() {
                VC.modalPresentationStyle = .fullScreen
                topVC.present(VC, animated: true)
            }
        }
    }
}

extension VerificationCodeVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 當輸入的字不為空字串時
        if (string != "") {
            //當textField不為空字串時
            if (textField.text == "") {
                textField.text = string
                //建立一個響應者為目前textField tag的下一個
                let nextResponder: UIResponder? = view.viewWithTag(textField.tag + 1)
                //只要響應者不是nil就讓他成為第一位響應者這樣就可以連續輸入時自動切到下一格
                if (nextResponder != nil) {
                    nextResponder?.becomeFirstResponder()
                }else{
                //當tag到最後時響應者會是nil此時執行將鍵盤收起的function
                    self.view.endEditing(true)
                    if let currentType = currentType {
                        let smsCodeStr = (firstTextField.text ?? "") + (secondTextField.text ?? "") + (thirdTextField.text ?? "") + (fourthTextField.text ?? "")
                        switch currentType {
                        case .sign:
                            signUpAction(smsCodeStr)
                        case .forgetPassword:
                            forgetPasswordAction(smsCodeStr)
                        }
                    }
                }
            }
            return false
        } else {//當我們按下刪除鍵時相當於輸入空字串
            textField.text = string
            //建立一個tag往前的響應者
            let nextResponder: UIResponder? = view.viewWithTag(textField.tag - 1)
            if (nextResponder != nil) {
            //只要響應者不是nil就讓他成為第一位響應者這樣就可以連續輸入時自動切到上一格
                nextResponder?.becomeFirstResponder()
            }
            return false
        }
    }
}
