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
    
    private struct LoginInfo:Codable {
        var userPhoneNumber:String
        var userPassword:String
    }
    
    private var testLoginInfo:LoginInfo = LoginInfo(userPhoneNumber: "0912345678", userPassword: "test123")
    
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
        if UserDefaults().bool(forKey: userDefaultKey.shared.biometrics) {
            evaluatePolicyAction { result, message in
                if result {
                    self.loginSuccess()
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
//        let loginInfo = LoginInfo(userPhoneNumber: phone!, userPassword: password!)
//        let loginInfoDic = try? loginInfo.asDictionary()
//        let testloginInfoDic = try? testLoginInfo.asDictionary()
//        requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.login, parameters: testloginInfoDic) { data in
//            print(String(data: data, encoding: .utf8))
//        }
        loginSuccess()
    }
    
    @IBAction func forgetPassword(_ sender:UIButton){
        if let VC = UIStoryboard(name: "ForgetPassword", bundle: nil).instantiateViewController(withIdentifier: "ForgetPassword") as? ForgetPasswordVC {
            VC.modalPresentationStyle = .fullScreen
            present(VC, animated: false)
        }
    }

}
