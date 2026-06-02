//
//  SignModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/21.
//

import UIKit

enum Gender: String, Codable {
    case male = "male"
    case female = "female"
    case LGBTQ = "LGBTQ"
    
    var displayName: String {
        switch self {
        case .male: return "男"
        case .female: return "女"
        case .LGBTQ: return "多元性別"
        }
    }
}

struct SignUpInfo: Codable {
    var userPhoneNumber: String
    var userPassword: String
    var smsCode: String
    var systemType: String = AppDeviceInfo.systemType
    var systemVersion: String = AppDeviceInfo.systemVersion
    var appVersion: String = AppDeviceInfo.appVersion
    var userName: String? = nil
    var userEmail: String? = nil
    var userBirth: String? = nil
    var gender: Gender? = nil
}

struct ActivityCodeInfo:Codable {
    var userID:String
    var activityCode:String
}

struct InviteCodeInfo:Codable {
    var userID:String
    var inviteCode:String
}
