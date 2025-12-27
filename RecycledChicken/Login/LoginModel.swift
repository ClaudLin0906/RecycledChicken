//
//  LoginModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/21.
//

import Foundation

struct AccountInfo: Codable {
    var userPhoneNumber: String
    var userPassword: String
}

struct LoginResponse: Codable {
    var token: String
}
