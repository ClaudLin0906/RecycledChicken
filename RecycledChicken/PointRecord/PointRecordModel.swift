//
//  PointRecordModel.swift
//  RecycledChicken
//
//  Created by sj on 2024/5/19.
//

import Foundation

struct PointRecord:Codable {
    var userID:String?
    var time:String?
    var reason:String?
    var point:Int?
    enum CodingKeys:String, CodingKey {
        case userID = "userID"
        case time = "time"
        case reason = "reason"
        case point = "point"

    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userID = try? container.decodeIfPresent(String.self, forKey: .userID)
        time = try? container.decodeIfPresent(String.self, forKey: .time)
        reason = try? container.decodeIfPresent(String.self, forKey: .reason)
        point = try? container.decodeIfPresent(Int.self, forKey: .point)
    }
}
