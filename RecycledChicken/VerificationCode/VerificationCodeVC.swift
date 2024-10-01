//
//  VerificationCodeVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/7.
//

import UIKit
import Alamofire
import Combine

class VerificationCodeVC: CustomLoginVC {
    
    @IBOutlet weak var firstTextField:UITextField!
    
    @IBOutlet weak var secondTextField:UITextField!
    
    @IBOutlet weak var thirdTextField:UITextField!
    
    @IBOutlet weak var fourthTextField:UITextField!
    
    @IBOutlet weak var goHomeBtn:CustomButton!
    
    @IBOutlet weak var reSendBtn:CustomButton!
    
    @IBOutlet weak var reSendBtnWidth:NSLayoutConstraint!
    {
        willSet {
            if reSendBtnWidth != nil {
                reSendVerificationCodeView.frame.size = CGSize(width:reSendBtnWidth.constant, height: reSendVerificationCodeView.frame.height)
            }
        }
    }
    
    var password:String = ""
    
    var phone:String = ""
    
    var currentType:VerificationCodeType?
    
    var info:forgetPasswordInfo?
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var reSendVerificationCodeView = ReSendVerificationCodeView()
    
    private var reSendVerificationCodeViewWidth = 200
        
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        sendSMS()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        goHomeBtn.addTarget(self, action: #selector(goSignLoginVC(_:)), for: .touchUpInside)
        if getLanguage() == .english {
            reSendBtnWidth.constant = 250
            reSendVerificationCodeViewWidth = 250
        }
    }
    
    private func startCountdown() {
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .scan(60) { currentCount, _ in
                return currentCount > 0 ? currentCount - 1 : 0
            }
            .sink { count in
                self.reSendVerificationCodeView.reciprocalLabel.text = "(\(count))"
                if count == 0 {
                    self.stopCountdown()
                }
            }
            .store(in: &cancellables)
    }
    
    private func stopCountdown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        reSendVerificationCodeView.removeFromSuperview()
    }
    
    private func addReSendVerificationCodeView() {
        reSendVerificationCodeView = ReSendVerificationCodeView(frame: CGRect(x: 0, y: 0, width: reSendVerificationCodeViewWidth, height: Int(reSendBtn.frame.height)))
        reSendBtn.addSubview(reSendVerificationCodeView)
    }
    
    private func sendSMS(){
        self.startCountdown()
        self.addReSendVerificationCodeView()
        
        switch currentType {
        case .forgetPassword:
            phone = info?.userPhoneNumber ?? ""
        default:
            break
        }
        let smsInfo = SMSInfo(userPhoneNumber: phone)
        let smsInfoDic = try? smsInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.smsCode, parameters: smsInfoDic) { (data, statusCode, errorMSG) in
            guard let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            let apiResult = try? JSONDecoder().decode(ApiResult.self, from: data)
            if let status = apiResult?.status {
                switch status {
                case .success:
                    self.startCountdown()
                    self.addReSendVerificationCodeView()
                case .failure:
                    break
                }
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
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            DispatchQueue.main.async {
                let signActivityCodeView = SignActivityCodeView(frame: UIScreen.main.bounds)
                signActivityCodeView.delegate = self
                signActivityCodeView.setUserID(self.phone)
                keyWindow?.addSubview(signActivityCodeView)
//                let alertAction = UIAlertAction(title: "確定", style: .default) { _ in
//                    self.goToLoginVC()
//                }
//                showAlert(VC: self, title: "註冊成功, 請重新登入", alertAction: alertAction)
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
            guard let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            let completetChangePWDView = CompletetChangePWDView(frame: UIScreen.main.bounds)
            fadeInOutAni(showView: completetChangePWDView) {
                let json = NetworkManager.shared.dataToDictionary(data: data)
                print(json)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let updatePasswordSuccessView = UpdatePasswordSuccessView(frame: view.frame)
                    fadeInOutAni(showView: updatePasswordSuccessView) {
                        self.goToLoginVC()
                    }
                }
            }
        }
    }
    
    func goToLoginVC() {
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


extension VerificationCodeVC:SignActivityCodeViewDelegate {
    func comfirmInvitationCode(finishAction: (() -> ())?) {
        DispatchQueue.main.async {
            finishAction?()
            self.goToLoginVC()
        }
    }
}
