//
//  LoginVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import UIKit
import M13Checkbox

class LoginVC: CustomLoginVC {
    
    @IBOutlet weak var keepLoginCheckBox:M13Checkbox!
    
    @IBOutlet weak var phoneTextfield:UITextField!
    
    @IBOutlet weak var passwordTextfield:UITextField!
        
    private var testLoginInfo:AccountInfo = AccountInfo(userPhoneNumber: "0912345678", userPassword: "test123")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        keepLoginCheckBox.boxType = .square
        keepLoginCheckBox.stateChangeAnimation = .fill
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults().bool(forKey: UserDefaultKey.shared.biometrics) {
            evaluatePolicyAction { result, message in
                if result {
                    let accountInfo = CurrentUserInfo.shared.currentAccountInfo
                    self.loginAction(phone: accountInfo.userPhoneNumber, password: accountInfo.userPassword)
                }
            }
        }
    }
    
    private func loginSuccess(){
        DispatchQueue.main.async { [self] in
            LoginSuccess = true
            dismiss(animated: true)
        }
    }
    
    private func loginAction(phone:String, password:String){
        let loginInfo = AccountInfo(userPhoneNumber: phone, userPassword: password)
        let loginInfoDic = try? loginInfo.asDictionary()
//        let testloginInfoDic = try? testLoginInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.login, parameters: loginInfoDic) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            
            if let data = data {
                let json = NetworkManager.shared.dataToDictionary(data: data)
                if let token = json["token"] as? String {
                    CommonKey.shared.authToken = ""
                    CommonKey.shared.authToken = token
                    CurrentUserInfo.shared.currentAccountInfo.userPhoneNumber = phone
                    CurrentUserInfo.shared.currentAccountInfo.userPassword = password
                    getUserInfo(VC: self, finishAction: {
                        self.loginSuccess()
                    })
                    
                }
            }
        }
    }
    
    @IBAction func login(_ sender:UIButton){
        var alertMsg = ""
        let phone = phoneTextfield.text
        let password = passwordTextfield.text
        
        if phone == "" {
            alertMsg += "電話不能為空"
        } else if !validateCellPhone(text: phone!) {
            alertMsg += "\n電話格式不對"
        }
        
        if password == "" {
            alertMsg += "\n密碼不能為空"
        }
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
            return
        }
        loginAction(phone: phone!, password: password!)
        
    }
    
    @IBAction func forgetPassword(_ sender:UIButton){
        if let VC = UIStoryboard(name: "ForgetPassword", bundle: nil).instantiateViewController(withIdentifier: "ForgetPassword") as? ForgetPasswordVC {
            VC.modalPresentationStyle = .fullScreen
            present(VC, animated: false)
        }
    }

}
