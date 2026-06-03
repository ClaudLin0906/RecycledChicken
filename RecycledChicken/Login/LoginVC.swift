//
//  LoginVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import UIKit
import M13Checkbox
import Combine

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
            
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        biometricsAction()
    }

    private func biometricsAction() {
        guard biometrics else { return }
        keepLoginCheckBox.checkState = .checked
        evaluatePolicyAction { [weak self] result, message in
            guard let self = self, result else { return }
            DispatchQueue.main.async {
                let accountInfo = CurrentUserInfo.shared.currentAccountInfo
                self.phoneTextfield.text = accountInfo.userPhoneNumber
                self.passwordTextfield.text = accountInfo.userPassword
                self.loginAction(phone: accountInfo.userPhoneNumber, password: accountInfo.userPassword)
            }
        }
    }
    
    private func loginSuccess() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if keepLoginCheckBox.checkState == .checked {
                biometrics = true
                _ = KeychainService.shared.saveJsonToKeychain(
                    jsonString: CurrentUserInfo.shared.currentAccountInfo.jsonString,
                    account: KeyChainKey.shared.accountInfo
                )
            } else {
                removeBiometricsAction()
            }
            LoginSuccess = true
            dismiss(animated: true)
        }
    }
    
    private func loginAction(phone: String, password: String) {
        let loginInfo = AccountInfo(userPhoneNumber: phone, userPassword: password)
        let loginInfoDic = try? loginInfo.asDictionary()
        NetworkManager.shared.post(url: APIUrl.domainName + APIUrl.login, parameters: loginInfoDic, authorizationToken: "", responseType: LoginResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                CommonKey.shared.authToken = response.token
                CurrentUserInfo.shared.currentAccountInfo.userPhoneNumber = phone
                CurrentUserInfo.shared.currentAccountInfo.userPassword = password
                if let self = self {
                    getUserNewInfo(VC: self) {
                        DispatchQueue.main.async {
                            self.checkProfileAndProceed()
                        }
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    showAlert(VC: self, title: "帳號密碼有誤", message: nil)
                }
            }
        }
    }
    
    private func checkProfileAndProceed() {
        let profile = CurrentUserInfo.shared.currentProfileNewInfo
        if profile?.gender == nil || (profile?.userBirth ?? "").isEmpty {
            showMissingInfoAlert()
        } else {
            loginSuccess()
        }
    }
    
    private func showMissingInfoAlert() {
        let missingInfoView = MissingInfoAlertView(frame: UIScreen.main.bounds)
        let profile = CurrentUserInfo.shared.currentProfileNewInfo
        if let birth = profile?.userBirth, !birth.isEmpty {
            missingInfoView.birthdayTextField.text = birth
        }
        if let gender = profile?.gender {
            missingInfoView.genderSelectionView.selectedGender = gender
        }
        
        let dismissAlert = { [weak missingInfoView] in
            DispatchQueue.main.async {
                missingInfoView?.removeFromSuperview()
            }
        }
        
        missingInfoView.onConfirm = { [weak self] birth, gender in
            self?.updateProfileInfo(gender: gender, birth: birth) { success in
                if success {
                    dismissAlert()
                }
            }
        }
        
        missingInfoView.onCancel = dismissAlert
        
        self.view.addSubview(missingInfoView)
    }
    
    private func updateProfileInfo(gender: Gender?, birth: String?, completion: ((Bool) -> Void)? = nil) {
        let profile = CurrentUserInfo.shared.currentProfileNewInfo
        let userName = profile?.userName ?? ""
        let userEmail = profile?.userEmail ?? ""
        let userBirth = birth ?? profile?.userBirth ?? ""
        let genderStr = gender?.rawValue ?? ""
        let profilePostInfo = ProfilePostInfo(userName: userName, userEmail: userEmail, userBirth: userBirth, gender: genderStr)
        guard let profilePostInfoDic = try? profilePostInfo.asDictionary() else {
            completion?(false)
            showAlert(VC: self, title: "資料格式錯誤", message: "請重新嘗試")
            return
        }
        NetworkManager.shared.post( url: APIUrl.domainName + APIUrl.updateProfile, parameters: profilePostInfoDic, authorizationToken: CommonKey.shared.authToken, responseType: ApiResult.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let apiResult):
                    if apiResult.status == .success {
                        if let self = self {
                            getUserNewInfo(VC: self) {
                                completion?(true)
                                self.loginSuccess()
                            }
                        } else {
                            completion?(true)
                        }
                    } else {
                        completion?(false)
                        if let self = self {
                            showAlert(VC: self, title: "更新失敗", message: apiResult.message ?? "請稍後再試")
                        }
                    }
                case .failure(let error):
                    completion?(false)
                    self?.handleNetworkError(error)
                }
            }
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        guard let phone = phoneTextfield.text, !phone.isEmpty else {
            showAlert(VC: self, title: nil, message: "電話不能為空")
            return
        }
        guard validateCellPhone(text: phone) else {
            showAlert(VC: self, title: nil, message: "電話格式不對")
            return
        }
        guard let password = passwordTextfield.text, !password.isEmpty else {
            showAlert(VC: self, title: nil, message: "密碼不能為空")
            return
        }
        loginAction(phone: phone, password: password)
    }
    
    @IBAction func forgetPassword(_ sender:UIButton){
        dismissAndPresent(from: self, storyboard: "ForgetPassword", identifier: "ForgetPassword")
    }

}
