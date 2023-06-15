//
//  VerificationCodeVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/7.
//

import UIKit
import Alamofire

class VerificationCodeVC: CustomLoginVC {
    
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
        sendSMS()
        // Do any additional setup after loading the view.
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
