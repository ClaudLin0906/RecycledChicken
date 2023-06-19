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
    
    var username:String = ""
    
    var phone:String = ""
    
    private let certificates: [Data] = {
            let url = Bundle.main.url(forResource: "cert", withExtension: "cer")!
            let data = try! Data(contentsOf: url)
            return [data]
    }()
    
    private struct SMSInfo:Codable {
        var userPhoneNumber:String
    }
    
    struct WeatherResponse: Decodable {

        var main: Main

        struct Main: Decodable {
            var tempMin: Double
            var tempMax: Double
        }
    }
    
    struct WeatherInfo:Codable{
        var lat:String
        var lon:String
        var units:String
        var appid:String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        sendSMS()
        
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
    }
    
    private func sendSMS(){
        let smsInfo = SMSInfo(userPhoneNumber: phone)
        let smsInfoDic = try? smsInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.smsCode, parameters: smsInfoDic) { data in
            print(String(data: data, encoding: .utf8))
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
