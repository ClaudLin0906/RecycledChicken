//
//  LoginModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/21.
//

import UIKit

struct AccountInfo: Codable {
    var userPhoneNumber: String
    var userPassword: String
    var systemType: String = "iOS"
    var systemVersion: String = "iOS\(UIDevice.current.systemVersion)"
    var appVersion: String = "v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")"
    
    enum CodingKeys: String, CodingKey {
        case userPhoneNumber
        case userPassword
        case systemType
        case systemVersion
        case appVersion
    }
    
    init(userPhoneNumber: String, userPassword: String) {
        self.userPhoneNumber = userPhoneNumber
        self.userPassword = userPassword
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userPhoneNumber = try container.decode(String.self, forKey: .userPhoneNumber)
        userPassword = try container.decode(String.self, forKey: .userPassword)
        systemType = (try? container.decode(String.self, forKey: .systemType)) ?? "IOS"
        systemVersion = (try? container.decode(String.self, forKey: .systemVersion)) ?? "IOS\(UIDevice.current.systemVersion)"
        appVersion = (try? container.decode(String.self, forKey: .appVersion)) ?? "v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")"
    }
}

struct LoginResponse: Codable {
    var token: String
}
