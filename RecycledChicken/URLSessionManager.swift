//
//  URLSessionManager.swift
//  Marais
//
//  Created by 林書郁 on 2022/3/18.
//

import Foundation

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    var session: URLSession!
    
    private override init() {
        super.init()
//        session = URLSession.init(configuration: .ephemeral, delegate: self, delegateQueue: nil)
        session = URLSession()

    }
    
    func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (Data?, Int?, String?) -> Void){
        let task = URLSession.shared.dataTask(with: request){(data,response,error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, nil, error?.localizedDescription)
                return
            }
            guard error == nil, httpResponse.statusCode == 200 else {
                completion(nil, httpResponse.statusCode, error?.localizedDescription)
                return
            }
            completion(data, httpResponse.statusCode, nil)
//            if error != nil, let httpResponse = response as? HTTPURLResponse{
//                print("url發生問題\(error.debugDescription)")
//                completion(nil, httpResponse.statusCode, error?.localizedDescription)
//            }else if{
//                if data != nil {
//                    completion(data!)
//                }else {
//                    print("Data is nil.")
//                }
//                //                guard let resultData = data else {return}
//            }
        }
        task.resume()
    }


    func requestWithJSONBody(urlString: String, parameters: [String: Any]? = nil, AuthorizationToken:String = "", completion: @escaping (Data?, Int?, String?) -> Void){
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        if parameters != nil {
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
            }catch let error{
                print(error)
            }
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(AuthorizationToken)", forHTTPHeaderField: "Authorization")
        fetchedDataByDataTask(from: request, completion: completion)
     }

    func getJSONBody(urlString: String, parameters: [String: Any]? = nil, authorizationToken:String? = nil, completion: @escaping (Data?, Int?, String?) -> Void){
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        if parameters != nil {
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
            }catch let error{
                print(error)
            }
        }
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authorizationToken = authorizationToken {
            request.addValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")
        }
        fetchedDataByDataTask(from: request, completion: completion)
     }

    func dataToDictionary(data:Data) -> Dictionary<String,Any>{
        var dic = Dictionary<String,Any>()
        do {
            let json = try JSONSerialization.jsonObject(with:data, options: .mutableContainers)
            dic = json as! Dictionary<String,Any>
        } catch  {
            print("\(error)")
        }
        return dic
    }
    
    
    func request<T: Decodable>(url: URL?, completion: @escaping (_ data: T?, _ error: Error?)-> ()) {
        
        guard let url else {
            print("cannot form url")
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            
            if let error {
                if error.localizedDescription == "cancelled" {
                    completion(nil, NSError.init(domain: "", code: -999, userInfo: [NSLocalizedDescriptionKey:"SSL Pinning Failed"]))
                    return
                }
                completion(nil, error)
                return
            }
            
            guard let data else {
                completion(nil, NSError.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"something went wrong"]))
                print("something went wrong")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(T.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
        
    }
}

extension NetworkManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust, let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            return
        }
        
        // Uncomment below for Certificate Pinning
        
        //SSL Policy for domain check
        let policy = NSMutableArray()
        policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))

        //Evaluate the certificate
        let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)

        //Local and Remote Certificate Data
        let remoteCertificateData: NSData = SecCertificateCopyData(certificate)

        let pathToCertificate = Bundle.main.path(forResource: "cert", ofType: "cer")
        let localCertificateData: NSData = NSData.init(contentsOfFile: pathToCertificate!)!

        //Compare Data of both certificates
        if (isServerTrusted && remoteCertificateData.isEqual(to: localCertificateData as Data)) {
            let credential: URLCredential = URLCredential(trust: serverTrust)
            print("Certification pinning is successfull")
            completionHandler(.useCredential, credential)
        } else {
            //failure happened
            print("Certification pinning is failed")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
        
    }
}
