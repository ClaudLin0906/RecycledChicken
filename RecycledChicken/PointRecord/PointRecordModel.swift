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

    enum CodingKeys: String, CodingKey {
        case userID, time, reason, point, prevPoint
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userID = try container.decodeIfPresent(String.self, forKey: .userID)
        time = try container.decodeIfPresent(String.self, forKey: .time)
        reason = try container.decodeIfPresent(String.self, forKey: .reason)
        point = Self.decodeFlexibleInt(container: container, key: .point)
        prevPoint = Self.decodeFlexibleInt(container: container, key: .prevPoint)
    }

    /// 嘗試將欄位解析為 Int；若 server 回傳的是 String，就轉換；格式不對一律回傳 nil（顯示 0）
    private static func decodeFlexibleInt(container: KeyedDecodingContainer<CodingKeys>, key: CodingKeys) -> Int? {
        if let intValue = try? container.decodeIfPresent(Int.self, forKey: key) {
            return intValue
        }
        if let stringValue = try? container.decodeIfPresent(String.self, forKey: key) {
            return Int(stringValue)
        }
        return nil
    }
}
