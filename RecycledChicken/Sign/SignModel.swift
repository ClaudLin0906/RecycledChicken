//
//  SignModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/21.
//

import Foundation

struct SignUpInfo:Codable {
    var userPhoneNumber:String
    var userPassword:String
    var smsCode:String
}

struct ActivityCodeInfo:Codable {
    var activityCode:String
}

struct InviteCodeInfo:Codable {
    var inviteCode:String
}
