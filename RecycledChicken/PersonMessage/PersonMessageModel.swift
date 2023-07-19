//
//  PersonMessageModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/19.
//

import Foundation

struct PersonMessageInfo:Decodable {
    var topicKey:String
    var message:String
    var createTime:String
}
