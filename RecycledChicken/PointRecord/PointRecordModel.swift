//
//  PointRecordModel.swift
//  RecycledChicken
//
//  Created by sj on 2024/5/19.
//

import Foundation

struct PointRecord: Codable {
    var userID: String?
    var time: String?
    var reason: String?
    var point: Int?
    var prevPoint: Int?
}
