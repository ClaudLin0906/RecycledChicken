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
    
    private lazy var session = URLSession(configuration: .default, delegate: self,
     delegateQueue: nil)
    
    private let certificates: [Data] = {
            let url = Bundle.main.url(forResource: "cert", withExtension: "der")!
            let data = try! Data(contentsOf: url)
            return [data]
    }()
    
    private struct SMSInfo:Codable {
        var userPhoneNumber:String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sendSMS()
        // Do any additional setup after loading the view.
    }
    
    private func sendSMS(){
//        let smsInfo = SMSInfo(userPhoneNumber: phone)
//        let smsInfoDic = try? smsInfo.asDictionary()
//        requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.smsCode, parameters: smsInfoDic) { data in
//            print(String(data: data, encoding: .utf8))
//        }
        
        let parameters = "{\n    \"userPhoneNumber\":\"0932266860\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://useries.buenooptics.com:8443/app/smsCode")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = session.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
        }

        task.resume()

    }
    
    @IBAction func reSendSMS(_ sender:UIButton) {
        sendSMS()
    }
    
    private func validate(trust: SecTrust, with policy: SecPolicy) -> Bool {
      let status = SecTrustSetPolicies(trust, policy)
      guard status == errSecSuccess else { return false }
      
      return SecTrustEvaluateWithError(trust, nil)
    }

}

extension VerificationCodeVC:URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        if let trust = challenge.protectionSpace.serverTrust, SecTrustGetCertificateCount(trust) > 0 {
//            let certificateCount = SecTrustGetCertificateCount(trust)
//
//            for i in 0..<certificateCount{
//                guard let certificate = SecTrustGetCertificateAtIndex(trust, i) else {
//                    continue
//                }
//                let data = SecCertificateCopyData(certificate) as Data
//                if certificates.contains(data) {
//                    print("成功")
//                    let certificateData = SecCertificateCopyData(certificate) as Data
//                    let certificateSubject = SecCertificateCopySubjectSummary(certificate) as! String
//                    completionHandler(.useCredential, URLCredential(trust: trust))
//                    return
//                }
//            }
//        }
//        completionHandler(.cancelAuthenticationChallenge, nil)
        guard
          challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
          let serverTrust = challenge.protectionSpace.serverTrust
        else {
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
            return
        }
        
        guard
          self.validate(trust: serverTrust, with: SecPolicyCreateBasicX509()),
          let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
        else {
          completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
          return
        }
        
        // Here you can do all addition check that you want on `serverCertificate` for example compare the
        // public keys or the data with the one pinned in your bundle.
        // I implemented for you a couple of useful methods that you can use here for your all checks.
        
        completionHandler(URLSession.AuthChallengeDisposition.useCredential,
                          URLCredential(trust:serverTrust))
    }
}
