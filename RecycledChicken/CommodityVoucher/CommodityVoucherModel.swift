//
//  CommodityVoucherModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/23.
//

import Foundation

//struct CommodityVoucherInfo: Codable {
//    var ttl:Int64?
//    var category:CouponsCategory?
//    var createTime:String?
//    var name:String?
//    var points:Int?
//    var start:String?
//    var end:String?
//    var remainingQuantity:Int?
//    var picture:String?
//    var description:String?
//    var notice:String?
//    var order:Int?
//    var expire:String?
//    
//    enum CodingKeys:String, CodingKey {
//        case ttl = "ttl"
//        case category = "category"
//        case createTime = "createTime"
//        case name = "name"
//        case points = "points"
//        case start = "start"
//        case end = "end"
//        case remainingQuantity = "remainingQuantity"
//        case picture = "picture"
//        case description = "description"
//        case notice = "notice"
//        case order = "order"
//        case expire = "expire"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        ttl = try? container.decodeIfPresent(Int64.self, forKey: .ttl)
//        category = try? container.decodeIfPresent(CouponsCategory.self, forKey: .category)
//        createTime = try? container.decodeIfPresent(String.self, forKey: .createTime)
//        name = try? container.decodeIfPresent(String.self, forKey: .name)
//        points = try? container.decodeIfPresent(Int.self, forKey: .points)
//        start = try? container.decodeIfPresent(String.self, forKey: .start)
//        end = try? container.decodeIfPresent(String.self, forKey: .end)
//        remainingQuantity = try? container.decodeIfPresent(Int.self, forKey: .remainingQuantity)
//        picture = try? container.decodeIfPresent(String.self, forKey: .picture)
//        description = try? container.decodeIfPresent(String.self, forKey: .description)
//        notice = try? container.decodeIfPresent(String.self, forKey: .notice)
//        order = try? container.decodeIfPresent(Int.self, forKey: .order)
//        expire = try? container.decodeIfPresent(String.self, forKey: .expire)
//    }
//}

struct CommodityVoucherInfo: Codable {
    var total: Int?
    var ttl: Int64?
    var createTime: String?
    var order: Int?
    var picture: String?
    var name: String?
    var expire: String?
    var remainingQuantity: Int?
    var notice: String?
    var points: Int?
    var category: CouponsCategory?
    var end: String?
    var description: String?
    var start: String?
    var isUnlocked: Bool?
    var link: String?
    
    enum CodingKeys: String, CodingKey {
        case total = "total"
        case ttl = "ttl"
        case createTime = "createTime"
        case order = "order"
        case picture = "picture"
        case name = "name"
        case expire = "expire"
        case remainingQuantity = "remainingQuantity"
        case notice = "notice"
        case points = "points"
        case category = "category"
        case end = "end"
        case description = "description"
        case start = "start"
        case isUnlocked = "isUnlocked"
        case link = "link"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total = try? container.decodeIfPresent(Int.self, forKey: .total)
        ttl = try? container.decodeIfPresent(Int64.self, forKey: .ttl)
        createTime = try? container.decodeIfPresent(String.self, forKey: .createTime)
        order = try? container.decodeIfPresent(Int.self, forKey: .order)
        picture = try? container.decodeIfPresent(String.self, forKey: .picture)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
        expire = try? container.decodeIfPresent(String.self, forKey: .expire)
        remainingQuantity = try? container.decodeIfPresent(Int.self, forKey: .remainingQuantity)
        notice = try? container.decodeIfPresent(String.self, forKey: .notice)
        points = try? container.decodeIfPresent(Int.self, forKey: .points)
        category = try? container.decodeIfPresent(CouponsCategory.self, forKey: .category)
        end = try? container.decodeIfPresent(String.self, forKey: .end)
        description = try? container.decodeIfPresent(String.self, forKey: .description)
        start = try? container.decodeIfPresent(String.self, forKey: .start)
        isUnlocked = try? container.decodeIfPresent(Bool.self, forKey: .isUnlocked)
        link = try? container.decodeIfPresent(String.self, forKey: .link)
    }
}

enum CouponsCategory: String, Codable {
    case ticket = "ticket"
    case event = "event"
    case partner = "partner"
}
