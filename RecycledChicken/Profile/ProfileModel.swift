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
    var systemType = "iOS"
    var systemVersion = UIDevice.current.systemVersion
    var appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
}

struct ProfileNewInfo: Codable {
    var userEmail:String?
    var userName:String?
    var userPhoneNumber:String?
    var userBirth:String?
    var invitCode:String?
    var linkedToBuenoMart:Bool?
    var point:Int?
    var experiencePoint:Int?
    var levelInfo:LevelInfo?
    
    enum CodingKeys:String, CodingKey {
        case userEmail = "userEmail"
        case userName = "userName"
        case userPhoneNumber = "userPhoneNumber"
        case userBirth = "userBirth"
        case invitCode = "invitCode"
        case linkedToBuenoMart = "linkedToBuenoMart"
        case point = "point"
        case experiencePoint = "experiencePoint"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userEmail = try? container.decodeIfPresent(String.self, forKey: .userEmail)
        userName = try? container.decodeIfPresent(String.self, forKey: .userName)
        userPhoneNumber = try? container.decodeIfPresent(String.self, forKey: .userPhoneNumber)
        userBirth = try? container.decodeIfPresent(String.self, forKey: .userBirth)
        invitCode = try? container.decodeIfPresent(String.self, forKey: .invitCode)
        linkedToBuenoMart = try? container.decodeIfPresent(Bool.self, forKey: .linkedToBuenoMart)
        point = try? container.decodeIfPresent(Int.self, forKey: .point)
        experiencePoint = try? container.decodeIfPresent(Int.self, forKey: .experiencePoint)
    }
}

struct LevelInfo:Codable {
    var progress:Int?
    var chickenLevel:IllustratedGuideModelLevel?
}
