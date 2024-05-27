//
//  PersonMessageModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/19.
//

import Foundation

struct PersonMessageInfo:Codable {
    var title:String?
    var createTime:String?
    var message:String?
    
    enum CodingKeys:String, CodingKey {
        case title = "title"
        case createTime = "createTime"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try? container.decodeIfPresent(String.self, forKey: .title)
        createTime = try? container.decodeIfPresent(String.self, forKey: .createTime)
        message = try? container.decodeIfPresent(String.self, forKey: .message)
    }
}
