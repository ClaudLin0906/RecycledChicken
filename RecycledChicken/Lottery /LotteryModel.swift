//
//  LotteryModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/16.
//

import Foundation

struct LotteryInfo: Codable {
    var itemName:String?
    var createTime:String?
    var productImage:String?
    var point:Int?
    var eventStartTime:String?
    var eventEndTime:String?
    var drawDate:String?
    var description:String?
    var notes:String?
    var purchaserCount:Int?
    var category: CouponsCategory = .ticket
    var isUnlocked: Bool?
    var url: String?
    var order:Int?
    
    enum CodingKeys:String, CodingKey {
        case itemName = "itemName"
        case createTime = "createTime"
        case productImage = "productImage"
        case point = "point"
        case eventStartTime = "eventStartTime"
        case eventEndTime = "eventEndTime"
        case drawDate = "drawDate"
        case description = "description"
        case notes = "notes"
        case purchaserCount = "purchaserCount"
        case isUnlocked = "isUnlocked"
        case url = "url"
        case order = "order"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        itemName = try? container.decodeIfPresent(String.self, forKey: .itemName)
        createTime = try? container.decodeIfPresent(String.self, forKey: .createTime)
        productImage = try? container.decodeIfPresent(String.self, forKey: .productImage)
        point = try? container.decodeIfPresent(Int.self, forKey: .point)
        eventStartTime = try? container.decodeIfPresent(String.self, forKey: .eventStartTime)
        eventEndTime = try? container.decodeIfPresent(String.self, forKey: .eventEndTime)
        drawDate = try? container.decodeIfPresent(String.self, forKey: .drawDate)
        description = try? container.decodeIfPresent(String.self, forKey: .description)
        notes = try? container.decodeIfPresent(String.self, forKey: .notes)
        purchaserCount = try? container.decodeIfPresent(Int.self, forKey: .purchaserCount)
        isUnlocked = try? container.decodeIfPresent(Bool.self, forKey: .isUnlocked)
        url = try? container.decodeIfPresent(String.self, forKey: .url)
        order = try? container.decodeIfPresent(Int.self, forKey: .order)
    }
}

struct CheckVerifyApiResult:Codable {
    var message:String?
    var status:ApiStatus?
    var unlockedAt:String?
    var isUnlocked:Bool?
    
    enum CodingKeys:String, CodingKey {
        case status = "status"
        case message = "message"
        case unlockedAt = "unlockedAt"
        case isUnlocked = "isUnlocked"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try? container.decodeIfPresent(String.self, forKey: .message)
        status = try? container.decodeIfPresent(ApiStatus.self, forKey: .status)
        unlockedAt = try? container.decodeIfPresent(String.self, forKey: .unlockedAt)
        isUnlocked = try? container.decodeIfPresent(Bool.self, forKey: .isUnlocked)
    }
}

struct checkVerifyCode:Codable {
    var name:String
    var createTime:String
    var category:String
    var unlockCode:String
}

var LotterySegmentedControlTitles = ["raffleTicket".localized, "activityAward".localized, "merchants".localized]


