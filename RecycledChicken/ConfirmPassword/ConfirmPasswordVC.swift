//
//  ConfirmPasswordVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/13.
//

import UIKit

class ConfirmPasswordVC: CustomLoginVC {
    
    var phone:String = ""
    
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
        }
        
        if confirmPWd == "" {
            alertMsg += "\n確認不能為空"
        }
        
        if newPWD != confirmPWd{
            alertMsg += "\n密碼不一致"
        }
        
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
            return
        }
        changePassword()
    }
    
    private func goToLoginVC(){
        self.dismiss(animated: false) {
            if let VC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login") as? LoginVC, let topVC = getTopController() {
                VC.modalPresentationStyle = .fullScreen
                topVC.present(VC, animated: true)
            }
        }
    }
    
    private func changePassword(){
        let resetPasswordInfo = resetPassword(userPhoneNumber: phone, changePassword: newPasswordTextField.text ?? "")
        let resetPasswordInfoDic = try? resetPasswordInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.changePWD, parameters: resetPasswordInfoDic) { (data, statusCode, errorMSG) in
            
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            
            if let data = data {
                let json = NetworkManager.shared.dataToDictionary(data: data)
                print(json)
                let updatePasswordSuccessView = UpdatePasswordSuccessView(frame: self.view.frame)
                fadeInOutAni(showView: updatePasswordSuccessView) {
                    self.goToLoginVC()
                }
            }
        }
    }
}
