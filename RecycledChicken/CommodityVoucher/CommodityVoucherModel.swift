//
//  CommodityVoucherModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/23.
//

import Foundation

struct CommodityVoucherInfo: Decodable {
    var createTime:String?
    var name:String?
    var points:Int?
    var start:String?
    var end:String?
    var remainingQuantity:Int?
    var picture:String?
    var description:String?
    
    enum CodingKeys:String, CodingKey {
        case createTime = "createTime"
        case name = "name"
        case points = "points"
        case start = "start"
        case end = "end"
        case remainingQuantity = "remainingQuantity"
        case picture = "picture"
        case description = "description"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createTime = try? container.decodeIfPresent(String.self, forKey: .createTime)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
        points = try? container.decodeIfPresent(Int.self, forKey: .points)
        start = try? container.decodeIfPresent(String.self, forKey: .start)
        end = try? container.decodeIfPresent(String.self, forKey: .end)
        remainingQuantity = try? container.decodeIfPresent(Int.self, forKey: .remainingQuantity)
        picture = try? container.decodeIfPresent(String.self, forKey: .picture)
        description = try? container.decodeIfPresent(String.self, forKey: .description)
    }
}
