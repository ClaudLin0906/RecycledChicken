//
//  ProfileModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/21.
//

import Foundation

struct ProfileInfo:Codable {
    var userEmail:String
    var userName:String
    var userBirth:String
    var point:Int
    var userPhoneNumber:String
    var experiencePoint:Int
    var levelInfo:LevelInfo?
}

struct LevelInfo:Codable {
    var chickenLevel:Int?
    var level:Int?
    var chickenLevelName:String?
}
