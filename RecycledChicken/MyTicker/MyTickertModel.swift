//
//  MyTickertModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/22.
//

import Foundation

struct MyTickertLotteryInfo:Codable {
    var activityStartTime:String?
    var activityEndTime:String?
    var lotteryDrawDate:String?
    var buyTime:String?
    var UUID:String?
    var userPhoneNumber:String?
    var itemName:String?
    var ttl:Int?

    enum CodingKeys:String, CodingKey {
        case activityStartTime = "activityStartTime"
        case activityEndTime = "activityEndTime"
        case lotteryDrawDate = "lotteryDrawDate"
        case buyTime = "buyTime"
        case UUID = "UUID"
        case userPhoneNumber = "userPhoneNumber"
        case itemName = "itemName"
        case ttl = "ttl"

    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        activityStartTime = try? container.decodeIfPresent(String.self, forKey: .activityStartTime)
        activityEndTime = try? container.decodeIfPresent(String.self, forKey: .activityEndTime)
        lotteryDrawDate = try? container.decodeIfPresent(String.self, forKey: .lotteryDrawDate)
        buyTime = try? container.decodeIfPresent(String.self, forKey: .buyTime)
        UUID = try? container.decodeIfPresent(String.self, forKey: .UUID)
        userPhoneNumber = try? container.decodeIfPresent(String.self, forKey: .userPhoneNumber)
        itemName = try? container.decodeIfPresent(String.self, forKey: .itemName)
        ttl = try? container.decodeIfPresent(Int.self, forKey: .ttl)
    }
}

struct MyTickertCouponsInfo:Codable {
    var code:String?
    var reward:Int?
    var userID:String?
    var data:String?
    var buyTime:String?
    var point:Int?
    var picture:String?
    var name:String?
    var expire:String?
    

    enum CodingKeys:String, CodingKey {
        case code = "code"
        case reward = "reward"
        case userID = "userID"
        case data = "data"
        case buyTime = "buyTime"
        case point = "point"
        case picture = "picture"
        case name = "name"
        case expire = "expire"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try? container.decodeIfPresent(String.self, forKey: .code)
        reward = try? container.decodeIfPresent(Int.self, forKey: .reward)
        userID = try? container.decodeIfPresent(String.self, forKey: .userID)
        data = try? container.decodeIfPresent(String.self, forKey: .data)
        buyTime = try? container.decodeIfPresent(String.self, forKey: .buyTime)
        point = try? container.decodeIfPresent(Int.self, forKey: .point)
        picture = try? container.decodeIfPresent(String.self, forKey: .picture)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
        expire = try? container.decodeIfPresent(String.self, forKey: .expire)
    }
}


var MyTickertTitles = ["raffleTicket".localized, "productvocher".localized]
