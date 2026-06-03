//
//  ProfileModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/21.
//

import Foundation
import UIKit

struct ProfilePostInfo:Codable {
    var userName:String
    var userEmail:String
    var userBirth:String
    var systemType: String = "iOS"
    var systemVersion: String = "iOS\(UIDevice.current.systemVersion)"
    var appVersion: String = "v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")"
    var gender: String
    
    init(userName: String, userEmail: String, userBirth: String, gender: String = "") {
        self.userName = userName
        self.userEmail = userEmail
        self.userBirth = userBirth
        self.gender = gender
    }
}

struct ProfileNewInfo: Codable {
    var userEmail:String?
    var userName:String?
    var userPhoneNumber:String?
    var userBirth:String?
    var inviteCode:String?
    var inputInviteCode:String?
    var linkedToBuenoMart:Bool?
    var point:Int?
    var expirePoint:Int?
    var experiencePoint:Int?
    var levelInfo:LevelInfo?
    var gender:Gender?
    
    enum CodingKeys:String, CodingKey {
        case userEmail = "userEmail"
        case userName = "userName"
        case userPhoneNumber = "userPhoneNumber"
        case userBirth = "userBirth"
        case inviteCode = "inviteCode"
        case inputInviteCode = "inputInviteCode"
        case linkedToBuenoMart = "linkedToBuenoMart"
        case point = "point"
        case expirePoint = "expirePoint"
        case experiencePoint = "experiencePoint"
        case levelInfo = "levelInfo"
        case gender = "gender"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userEmail = try? container.decodeIfPresent(String.self, forKey: .userEmail)
        userName = try? container.decodeIfPresent(String.self, forKey: .userName)
        userPhoneNumber = try? container.decodeIfPresent(String.self, forKey: .userPhoneNumber)
        userBirth = try? container.decodeIfPresent(String.self, forKey: .userBirth)
        inviteCode = try? container.decodeIfPresent(String.self, forKey: .inviteCode)
        inputInviteCode = try? container.decodeIfPresent(String.self, forKey: .inputInviteCode)
        linkedToBuenoMart = try? container.decodeIfPresent(Bool.self, forKey: .linkedToBuenoMart)
        point = try? container.decodeIfPresent(Int.self, forKey: .point)
        expirePoint = try? container.decodeIfPresent(Int.self, forKey: .expirePoint)
        experiencePoint = try? container.decodeIfPresent(Int.self, forKey: .experiencePoint)
        levelInfo = try? container.decodeIfPresent(LevelInfo.self, forKey: .levelInfo)
        gender = try? container.decodeIfPresent(Gender.self, forKey: .gender)
    }
}

struct LevelInfo:Codable {
    var progress:Int?
    var chickenLevel:IllustratedGuideModelLevel?
}
