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
                completion(data, httpResponse.statusCode, error?.localizedDescription)
                return
            }
            completion(data, httpResponse.statusCode, nil)
        }
        task.resume()
    }


    func requestWithJSONBody(urlString: String, parameters: [String: Any]? = nil, parametersArray: [[String: Any]]? = nil, authorizationToken:String = "", completion: @escaping (Data?, Int?, String?) -> Void){
        let url = URL(string: urlString.urlEncoded())!
        var request = URLRequest(url: url)
        if parameters != nil {
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
            }catch let error{
                print(error)
            }
        }
        if parametersArray != nil {
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: parametersArray, options: JSONSerialization.WritingOptions())
            }catch let error{
                print(error)
            }
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")
        fetchedDataByDataTask(from: request, completion: completion)
     }

    func getJSONBody(urlString: String, parameters: [String: Any]? = nil, authorizationToken:String? = nil, completion: @escaping (Data?, Int?, String?) -> Void){
        let url = URL(string: urlString.urlEncoded())!
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
    
    private func extractIdentity() -> IdentityAndTrust? {
        print("URLSessionDelegate 获取客户端证书相关信息")
        var identityAndTrust: IdentityAndTrust?
        var securityError: OSStatus = errSecSuccess
        
        guard let path = Bundle.main.path(forResource: "certificate", ofType: "p12") else {
            print("证书文件未找到")
            return nil
        }
        
        guard let PKCS12Data = NSData(contentsOfFile: path) else {
            print("无法读取证书文件")
            return nil
        }
        print("PKCS12Data size: \(PKCS12Data.length)")
        // iOS 17 兼容的多重尝试策略
        let importOptions: [[String: Any]] = [
            [kSecImportExportPassphrase as String: "claud"] 
        ]
        
        var items: CFArray?
        
        for (index, options) in importOptions.enumerated() {
            items = nil
            let optionsDict = options as CFDictionary
            securityError = SecPKCS12Import(PKCS12Data, optionsDict, &items)
            
            print("尝试导入策略 \(index + 1): \(securityError == errSecSuccess ? "成功" : "失败(\(securityError))")")
            
            if securityError == errSecSuccess, let certItems = items {
                print("证书导入成功，使用策略 \(index + 1)")
                identityAndTrust = self.parseImportResult(certItems)
                break
            } else {
                // 详细错误信息
                self.printSecurityError(securityError)
            }
        }
        
        if identityAndTrust == nil {
            print("所有导入策略都失败")
        }
        
        return identityAndTrust
    }
    
    private func parseImportResult(_ items: CFArray) -> IdentityAndTrust? {
        let certItemsArray = items as Array<AnyObject>
        
        guard let dict = certItemsArray.first as? Dictionary<String, AnyObject> else {
            print("证书格式错误")
            return nil
        }
        
        // 使用标准的导入结果键
        guard let identityPointer = dict[kSecImportItemIdentity as String],
              let trustPointer = dict[kSecImportItemTrust as String],
              let chainPointer = dict[kSecImportItemCertChain as String] else {
            
            print("证书内容不完整")
            print("可用的键: \(dict.keys)")
            
            // 尝试使用旧版本的键（向后兼容）
            if let identity = dict["identity"],
               let trust = dict["trust"],
               let chain = dict["chain"] {
                let secIdentityRef = identity as! SecIdentity
                let trustRef = trust as! SecTrust
                return IdentityAndTrust(identityRef: secIdentityRef, trust: trustRef, certArray: chain)
            }
            
            return nil
        }
        
        let secIdentityRef = identityPointer as! SecIdentity
        let trustRef = trustPointer as! SecTrust
        
        return IdentityAndTrust(
            identityRef: secIdentityRef,
            trust: trustRef,
            certArray: chainPointer
        )
    }
    
    private func printSecurityError(_ error: OSStatus) {
        switch error {
        case errSecSuccess:
            print("成功")
        case errSecAuthFailed:
            print("认证失败 (-25293)")
        case errSecDecode:
            print("解码失败")
        case errSecParam:
            print("参数错误")
        case errSecAllocate:
            print("内存分配失败")
        case errSecNotAvailable:
            print("服务不可用")
        case errSecDuplicateItem:
            print("重复项目")
        case errSecItemNotFound:
            print("项目未找到")
        default:
            print("未知错误: \(error)")
        }
    }
    
    // 验证导入的证书是否有效
    private func validateIdentity(_ identity: IdentityAndTrust) -> Bool {
        var certificate: SecCertificate?
        let status = SecIdentityCopyCertificate(identity.identityRef, &certificate)
        
        if status == errSecSuccess {
            print("证书验证通过")
            return true
        } else {
            print("证书验证失败: \(status)")
            return false
        }
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
        
        // 服务器证书认证
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            print("URLSessionDelegate 服务端证书认证！")
            handleServerTrustChallenge(challenge: challenge, completionHandler: completionHandler)
            
        } else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
            print("URLSessionDelegate 客户端证书认证！")
            handleClientCertificateChallenge(challenge: challenge, completionHandler: completionHandler)
            
        } else {
            print("URLSessionDelegate 其他认证方式")
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    private func handleServerTrustChallenge(challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust,
              let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        let remoteCertificateData = SecCertificateCopyData(certificate)
        
        guard let cerPath = Bundle.main.path(forResource: "cert", ofType: "cer"),
              let localCertificateData = try? Data(contentsOf: URL(fileURLWithPath: cerPath)) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        let remoteCertificateDataNS = CFBridgingRetain(remoteCertificateData) as! NSData
        
        if remoteCertificateDataNS.isEqual(to: localCertificateData) {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            // iOS 17 中可能需要更宽松的处理
            if #available(iOS 17.0, *) {
                // 可以选择继续默认处理而不是直接取消
                completionHandler(.performDefaultHandling, nil)
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }
    }
    
    private func handleClientCertificateChallenge(challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let identityAndTrust = self.extractIdentity() else {
            print("获取客户端证书失败")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // iOS 17 特殊处理
        if #available(iOS 17.0, *) {
            // 使用 .none persistence 而不是 .forSession
            let urlCredential = URLCredential(
                identity: identityAndTrust.identityRef,
                certificates: identityAndTrust.certArray as? [AnyObject],
                persistence: .none
            )
            completionHandler(.useCredential, urlCredential)
        } else {
            let urlCredential = URLCredential(
                identity: identityAndTrust.identityRef,
                certificates: identityAndTrust.certArray as? [AnyObject],
                persistence: .forSession
            )
            completionHandler(.useCredential, urlCredential)
        }
    }
}

//定义一个结构体，存储认证相关信息
struct IdentityAndTrust {
    var identityRef: SecIdentity
    var trust: SecTrust
    var certArray: AnyObject
    
    @available(iOS 17.0, *)
    func isValidForIOS17() -> Bool {
        // 可以添加额外的验证逻辑
        return true
    }
    
}
