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
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration, delegate: self, delegateQueue:OperationQueue.main)
    }
    
    func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (Data?, Int?, String?) -> Void){
        let task = session.dataTask(with: request){(data,response,error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, nil, error?.localizedDescription)
                return
            }
            guard error == nil, httpResponse.statusCode == 200 else {
                completion(nil, httpResponse.statusCode, error?.localizedDescription)
                return
            }
            completion(data, httpResponse.statusCode, nil)
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
    
    private func extractIdentity() -> IdentityAndTrust {
        print("URLSessionDelegate 获取客户端证书相关信息")
        var identityAndTrust:IdentityAndTrust!
        var securityError:OSStatus = errSecSuccess
        
        let path: String = Bundle.main.path(forResource: "certificate", ofType: "p12")!
        let PKCS12Data = NSData(contentsOfFile:path)!
        let key = kSecImportExportPassphrase as NSString
        let options: NSDictionary = [key : "0000"] //客户端证书密码
        //create variable for holding security information
        //var privateKeyRef: SecKeyRef? = nil
        
        var items : CFArray?
        
        securityError = SecPKCS12Import(PKCS12Data, options, &items)
        
        if securityError == errSecSuccess, let certItems:CFArray = items {
            let certItemsArray:Array = certItems as Array
            let dict:AnyObject? = certItemsArray.first
            if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject> {
                let identityPointer:AnyObject? = certEntry["identity"];
                let secIdentityRef:SecIdentity = identityPointer as! SecIdentity
                let trustPointer:AnyObject? = certEntry["trust"]
                let trustRef:SecTrust = trustPointer as! SecTrust
                let chainPointer:AnyObject? = certEntry["chain"]
                identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef, trust: trustRef, certArray:  chainPointer!)
            }
        }
        return identityAndTrust;
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
        print("URLSessionDelegate 证书认证！")
        //认证服务器证书
        if challenge.protectionSpace.authenticationMethod == (NSURLAuthenticationMethodServerTrust) {
            print("URLSessionDelegate 服务端证书认证！")
            guard let serverTrust:SecTrust = challenge.protectionSpace.serverTrust,
                  let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0),
                  let remoteCertificateData = CFBridgingRetain(SecCertificateCopyData(certificate)) else {
                
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            
            guard let cerPath = Bundle.main.path(forResource: "cert", ofType: "cer") else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            let cerUrl = URL(fileURLWithPath:cerPath)
            guard let localCertificateData = try? Data(contentsOf: cerUrl) else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            
            if (remoteCertificateData.isEqual(localCertificateData)) {
                let credential = URLCredential(trust: serverTrust)
                challenge.sender?.use(credential, for: challenge)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
                
            } else {
                //completionHandler(.cancelAuthenticationChallenge, nil)
                completionHandler(.performDefaultHandling, nil)
            }
            
        } else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
            //认证客户端证书
            print("URLSessionDelegate 客户端证书认证！")
            //获取客户端证书相关信息
            let identityAndTrust:IdentityAndTrust = self.extractIdentity()
            
            let urlCredential:URLCredential = URLCredential(identity: identityAndTrust.identityRef,
                                                            certificates: identityAndTrust.certArray as? [AnyObject],
                                                            persistence: URLCredential.Persistence.forSession)
            
            completionHandler(.useCredential, urlCredential)
            
        } else {
            // 其它情况（不接受认证）
            print("URLSessionDelegate 其它情况（不接受认证）")
            completionHandler(.cancelAuthenticationChallenge, nil);
        }
    }
}

//定义一个结构体，存储认证相关信息
struct IdentityAndTrust {
    var identityRef:SecIdentity
    var trust:SecTrust
    var certArray:AnyObject
}
