//
//  CommodityVoucherModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/23.
//

import Foundation

struct CommodityVoucherInfo: Codable {
    var category:CouponsCategory?
    var createTime:String?
    var name:String?
    var points:Int?
    var start:String?
    var end:String?
    var remainingQuantity:Int?
    var picture:String?
    var description:String?
    var notice:String?
    var order:Int?
    var expire:String?
    
    enum CodingKeys:String, CodingKey {
        case category = "category"
        case createTime = "createTime"
        case name = "name"
        case points = "points"
        case start = "start"
        case end = "end"
        case remainingQuantity = "remainingQuantity"
        case picture = "picture"
        case description = "description"
        case notice = "notice"
        case order = "order"
        case expire = "expire"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        category = try? container.decodeIfPresent(CouponsCategory.self, forKey: .category)
        createTime = try? container.decodeIfPresent(String.self, forKey: .createTime)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
        points = try? container.decodeIfPresent(Int.self, forKey: .points)
        start = try? container.decodeIfPresent(String.self, forKey: .start)
        end = try? container.decodeIfPresent(String.self, forKey: .end)
        remainingQuantity = try? container.decodeIfPresent(Int.self, forKey: .remainingQuantity)
        picture = try? container.decodeIfPresent(String.self, forKey: .picture)
        description = try? container.decodeIfPresent(String.self, forKey: .description)
        notice = try? container.decodeIfPresent(String.self, forKey: .notice)
        order = try? container.decodeIfPresent(Int.self, forKey: .order)
        expire = try? container.decodeIfPresent(String.self, forKey: .expire)
    }
}

enum CouponsCategory: String, Codable {
    case ticket = "ticket"
    case event = "event"
    case partner = "partner"
}
