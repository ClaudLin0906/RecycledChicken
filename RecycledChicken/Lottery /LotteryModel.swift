//
//  LotteryModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/16.
//

import Foundation

struct LotteryInfo: Decodable {
    var itemName:String?
    var createTime:String?
    var productImage:String?
    var point:Int?
    var evnetStartTime:String?
    var eventEndTime:String?
    var drawDate:String?
    var description:String?
    var notes:String?
    var purchaserCount:Int?
    var order:Int?
    
    enum CodingKeys:String, CodingKey {
        case itemName = "itemName"
        case createTime = "createTime"
        case productImage = "productImage"
        case point = "point"
        case evnetStartTime = "evnetStartTime"
        case eventEndTime = "eventEndTime"
        case drawDate = "drawDate"
        case description = "description"
        case notes = "notes"
        case purchaserCount = "purchaserCount"
        case order = "order"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        itemName = try? container.decodeIfPresent(String.self, forKey: .itemName)
        createTime = try? container.decodeIfPresent(String.self, forKey: .createTime)
        productImage = try? container.decodeIfPresent(String.self, forKey: .productImage)
        point = try? container.decodeIfPresent(Int.self, forKey: .point)
        evnetStartTime = try? container.decodeIfPresent(String.self, forKey: .evnetStartTime)
        eventEndTime = try? container.decodeIfPresent(String.self, forKey: .eventEndTime)
        drawDate = try? container.decodeIfPresent(String.self, forKey: .drawDate)
        description = try? container.decodeIfPresent(String.self, forKey: .description)
        notes = try? container.decodeIfPresent(String.self, forKey: .notes)
        purchaserCount = try? container.decodeIfPresent(Int.self, forKey: .purchaserCount)
        order = try? container.decodeIfPresent(Int.self, forKey: .order)
    }
}

var LotterySegmentedControlTitles = ["raffleTicket".localized, "activityAward".localized, "merchants".localized]


