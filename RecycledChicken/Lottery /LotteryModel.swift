//
//  LotteryModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/16.
//

import Foundation

struct LotteryInfo: Decodable {
    var itemName:String?
    var point:Int?
    var productImage:String?
    var eventStartTime:String?
    var eventEndTime:String?
    var drawDate:String?
    var description:String?
    var notes:String?
    var purchaserCount:Int?
    var createTime:String?
    
    enum CodingKeys:String, CodingKey {
        case itemName = "itemName"
        case point = "point"
        case productImage = "productImage"
        case eventStartTime = "eventStartTime"
        case eventEndTime = "eventEndTime"
        case drawDate = "drawDate"
        case description = "description"
        case notes = "notes"
        case purchaserCount = "purchaserCount"
        case createTime = "createTime"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        itemName = try? container.decodeIfPresent(String.self, forKey: .itemName)
        point = try? container.decodeIfPresent(Int.self, forKey: .point)
        productImage = try? container.decodeIfPresent(String.self, forKey: .productImage)
        eventStartTime = try? container.decodeIfPresent(String.self, forKey: .eventStartTime)
        eventEndTime = try? container.decodeIfPresent(String.self, forKey: .eventEndTime)
        drawDate = try? container.decodeIfPresent(String.self, forKey: .drawDate)
        description = try? container.decodeIfPresent(String.self, forKey: .description)
        notes = try? container.decodeIfPresent(String.self, forKey: .notes)
        purchaserCount = try? container.decodeIfPresent(Int.self, forKey: .purchaserCount)
        createTime = try? container.decodeIfPresent(String.self, forKey: .createTime)
    }
}

enum LotteryCategory: String, Codable {
    case ticket = "ticket"
    case event = "event"
    case partner = "partner"
}

var LotterySegmentedControlTitles = ["raffleTicket".localized, "activityAward".localized, "merchants".localized]


