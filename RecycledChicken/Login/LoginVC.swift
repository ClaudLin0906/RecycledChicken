//
//  LoginVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import UIKit
import M13Checkbox
import Combine
import CombineHelper

class LoginVC: CustomLoginVC {
    
    @IBOutlet weak var keepLoginCheckBox:M13Checkbox!
    
    @IBOutlet weak var phoneTextfield:UITextField!
    
    @IBOutlet weak var passwordTextfield:UITextField!
    
    @IBOutlet weak var goHomeBtn:CustomButton!
    
    @IBOutlet weak var mobileLabelWidth:NSLayoutConstraint!
    
    @IBOutlet weak var passwordLabelWidth:NSLayoutConstraint!
    
    @IBOutlet weak var keepLoginBtnWidth:NSLayoutConstraint!
    
    @IBOutlet weak var forgetPasswordWidth:NSLayoutConstraint!
        
    private var testLoginInfo:AccountInfo = AccountInfo(userPhoneNumber: "0912345678", userPassword: "test123")
            
    @UserDefault(UserDefaultKey.shared.biometrics, defaultValue: false) var biometrics:Bool
    
    @UserDefault(UserDefaultKey.shared.keepLogin, defaultValue: false) var keepLogin:Bool
        
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        keepLoginCheckBox.boxType = .square
        keepLoginCheckBox.stateChangeAnimation = .fill
        goHomeBtn.addTarget(self, action: #selector(goSignLoginVC(_:)), for: .touchUpInside)
        
        if getLanguage() == .english {
            mobileLabelWidth.constant = 50
            passwordLabelWidth.constant = 100
            keepLoginBtnWidth.constant = 150
            forgetPasswordWidth.constant = 150
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if biometrics {
            evaluatePolicyAction { result, message in
                if result {
                    let accountInfo = CurrentUserInfo.shared.currentAccountInfo
                    self.loginAction(phone: accountInfo.userPhoneNumber, password: accountInfo.userPassword)
                }
            }
        } else if keepLogin {
            let accountInfo = CurrentUserInfo.shared.currentAccountInfo
            self.loginAction(phone: accountInfo.userPhoneNumber, password: accountInfo.userPassword)
        }
        
    }
    
    private func loginSuccess(){
        DispatchQueue.main.async { [self] in
            if keepLoginCheckBox.checkState == .checked {
                UserDefaults().set(true, forKey: UserDefaultKey.shared.biometrics)
                if let accountInfo = try? CurrentUserInfo.shared.currentAccountInfo.jsonString {
                    let _ = KeychainService.shared.saveJsonToKeychain(jsonString: accountInfo, account: KeyChainKey.shared.accountInfo)
                }
            }else{
                removeBiometricsAction()
            }

            LoginSuccess = true
            dismiss(animated: true)
        }
    }
    
    private func loginAction(phone:String, password:String){
        let loginInfo = AccountInfo(userPhoneNumber: phone, userPassword: password)
//        let loginInfo = testLoginInfo
        let loginInfoDic = try? loginInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.login, parameters: loginInfoDic) { (data, statusCode, errorMSG) in
            guard let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "帳號密碼有誤", message: nil)
                return
            }
            let json = NetworkManager.shared.dataToDictionary(data: data)
            if let token = json["token"] as? String {
                CommonKey.shared.authToken = ""
                CommonKey.shared.authToken = token
                CurrentUserInfo.shared.currentAccountInfo.userPhoneNumber = phone
                CurrentUserInfo.shared.currentAccountInfo.userPassword = password
                self.loginSuccess()
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
            alertMsg += "電話格式不對"
        }
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
            return
        }

        if password == "" {
            alertMsg += "密碼不能為空"
        }
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
            return
        }

        loginAction(phone: phone!, password: password!)
        
    }
    
    @IBAction func forgetPassword(_ sender:UIButton){
        self.dismiss(animated: false) {
            if let VC = UIStoryboard(name: "ForgetPassword", bundle: nil).instantiateViewController(withIdentifier: "ForgetPassword") as? ForgetPasswordVC, let topVC = getTopController() {
                VC.modalPresentationStyle = .fullScreen
                topVC.present(VC, animated: true)
            }
        }
    }

}
