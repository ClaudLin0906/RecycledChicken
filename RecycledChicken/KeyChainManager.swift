//
//  KeyChainManager.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/21.
//

import Foundation
import Security

class KeychainService {
    
    static let shared = KeychainService()
    
    let kSecClassValue = NSString(format: kSecClass)
    let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
    let kSecValueDataValue = NSString(format: kSecValueData)
    let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
    let kSecAttrServiceValue = NSString(format: kSecAttrService)
    let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
    let kSecReturnDataValue = NSString(format: kSecReturnData)
    let kSecMatchLimitOneValue = kSecMatchLimitOne
    
    func saveJSONToKeychain(jsonString: String, account: String, service: String) -> Bool {
        if let data = jsonString.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClassValue as String: kSecClassGenericPasswordValue,
                kSecAttrAccountValue as String: account,
                kSecAttrServiceValue as String: service,
                kSecValueDataValue as String: data
            ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            if status == errSecSuccess {
                return true
            }
        }
        
        return false
    }
    
    func loadJSONFromKeychain(account: String, service: String) -> String? {
        let query: [String: Any] = [
            kSecClassValue as String: kSecClassGenericPasswordValue,
            kSecAttrAccountValue as String: account,
            kSecAttrServiceValue as String: service,
            kSecMatchLimitValue as String: kSecMatchLimitOneValue,
            kSecReturnDataValue as String: kCFBooleanTrue!
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess {
            if let data = result as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        
        return nil
    }
}
