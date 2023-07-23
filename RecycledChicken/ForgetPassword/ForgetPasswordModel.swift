//
//  ForgetPasswordModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/23.
//

import Foundation

struct forgetPasswordInfo:Codable {
    var userPhoneNumber:String
    var newPassword:String
    var smsCode:String
}
