//
//  VerificationCodeModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/21.
//

import Foundation

struct SMSInfo:Codable {
    var userPhoneNumber:String
}

enum VerificationCodeType{
    case sign
    case forgetPassword
}
