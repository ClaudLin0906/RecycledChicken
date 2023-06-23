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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        sendSMS()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        
    }
    
    private func sendSMS(){
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
        
//        let weatherInfo = WeatherInfo(lat: "28.7041", lon: "77.1025", units: "metric", appid: "26f1ffa29736dc1105d00b93743954d2")
//        let weatherInfoDic = try? weatherInfo.asDictionary()
//
//        NetworkManager.shared.requestWithJSONBody(urlString: "https://api.openweathermap.org/data/2.5/weather", parameters: weatherInfoDic) { data in
//                print(String(data: data, encoding: .utf8))
//        }
//        var url = URL.init(string: "https://api.openweathermap.org/data/2.5/weather")
//        
//        let queryItems = [
//            URLQueryItem.init(name: "lat", value: "28.7041"),
//            URLQueryItem.init(name: "lon", value: "77.1025"),
//            URLQueryItem.init(name: "units", value: "metric"),
//            URLQueryItem.init(name: "appid", value: "26f1ffa29736dc1105d00b93743954d2"),
//        ]
//
//        if #available(iOS 16.0, *) {
//            url?.append(queryItems: queryItems)
//        } else {
//            // Fallback on earlier versions
//            var components = URLComponents.init(url: url!, resolvingAgainstBaseURL: false)
//            components?.queryItems = queryItems
//            url = components?.url
//        }
//        NetworkManager.shared.request(url: url, expecting: WeatherResponse.self) { data, error in
//            if let error {
//                let alert = UIAlertController.init(title: error.localizedDescription, message: "", preferredStyle: .alert)
//                alert.addAction(UIAlertAction.init(title: "Ok", style: .cancel))
//                DispatchQueue.main.async {
//                    self.present(alert, animated: true)
//                }
//                print(error.localizedDescription)
//                return
//            }
//
//            if let data {
//                DispatchQueue.main.async {
//                    print("tempMin \(data.main.tempMin)")
//                    print("tempMax \(data.main.tempMax)")
//                }
//            }
//        }

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
        guard smsCode.count == 4 else { return }
        let forgetInfo = ForgetPasswordInfo(userPhoneNumber: phone, smsCode: smsCode)
        let forgetDic = try? forgetInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.smsCertificate, parameters: forgetDic) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            self.goToConfirmVC()
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
