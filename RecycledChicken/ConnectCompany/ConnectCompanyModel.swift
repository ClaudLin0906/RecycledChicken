//
//  ConnectCompanyModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/16.
//

import Foundation

struct SendEmailInfo:Codable {
    var recipient:String
    var content:String
    var email:String
    var userName:String
}
