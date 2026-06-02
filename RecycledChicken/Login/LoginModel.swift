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
    var systemType: String = AppDeviceInfo.systemType
    var systemVersion: String = AppDeviceInfo.systemVersion
    var appVersion: String = AppDeviceInfo.appVersion
    
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
        systemType = (try? container.decode(String.self, forKey: .systemType)) ?? AppDeviceInfo.systemType
        systemVersion = (try? container.decode(String.self, forKey: .systemVersion)) ?? AppDeviceInfo.systemVersion
        appVersion = (try? container.decode(String.self, forKey: .appVersion)) ?? AppDeviceInfo.appVersion
    }
}

struct LoginResponse: Codable {
    var token: String
}
