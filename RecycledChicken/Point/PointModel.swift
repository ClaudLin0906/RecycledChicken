//
//  PointModel.swift
//  RecycledChicken
//
//  Created by sj on 2024/10/22.
//

import Foundation

struct PointBtnImage: Codable {
    var eventLottery:String?
    var coupon:String?
    var product:String?
    
    enum CodingKeys:String, CodingKey {
        case eventLottery = "eventLottery"
        case coupon = "coupon"
        case product = "product"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventLottery = try? container.decodeIfPresent(String.self, forKey: .eventLottery)
        coupon = try? container.decodeIfPresent(String.self, forKey: .coupon)
        product = try? container.decodeIfPresent(String.self, forKey: .product)
    }
}
