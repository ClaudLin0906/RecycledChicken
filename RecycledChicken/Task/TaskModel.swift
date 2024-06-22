//
//  TaskModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/16.
//

import Foundation

struct TaskInfo: Codable {
    var createTime:String?
    var startTime:String?
    var endTime:String?
    var title:String?
    var description:String?
    var type:TaskType?
    var reward:TaskReward?
    var iconUrl:String?
    var requiredAmount:Int?
    var sites:String?
    var url:String?
    var ttl:Int64?
    var leftIcon:String?
    var isFinish:Bool
    var isSpecifiedLocation:Bool
    
    enum CodingKeys:String, CodingKey {
        case createTime = "createTime"
        case startTime = "startTime"
        case endTime = "endTime"
        case title = "title"
        case description = "description"
        case type = "type"
        case reward = "reward"
        case iconUrl = "iconUrl"
        case requiredAmount = "requiredAmount"
        case sites = "sites"
        case url = "url"
        case ttl = "ttl"
        case leftIcon = "leftIcon"
        case isFinish = "isFinish"
        case isSpecifiedLocation = "isSpecifiedLocation"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createTime = try? container.decodeIfPresent(String.self, forKey: .createTime)
        startTime = try? container.decodeIfPresent(String.self, forKey: .startTime)
        endTime = try? container.decodeIfPresent(String.self, forKey: .endTime)
        title = try? container.decodeIfPresent(String.self, forKey: .title)
        description = try? container.decodeIfPresent(String.self, forKey: .description)
        type = try? container.decodeIfPresent(TaskType.self, forKey: .type)
        reward = try? container.decodeIfPresent(TaskReward.self, forKey: .reward)
        iconUrl = try? container.decodeIfPresent(String.self, forKey: .iconUrl)
        requiredAmount = try? container.decodeIfPresent(Int.self, forKey: .requiredAmount)
        sites = try? container.decodeIfPresent(String.self, forKey: .sites)
        url = try? container.decodeIfPresent(String.self, forKey: .url)
        ttl = try? container.decodeIfPresent(Int64.self, forKey: .ttl)
        leftIcon = try? container.decodeIfPresent(String.self, forKey: .leftIcon)
        isFinish = false
        isSpecifiedLocation = false
    }

}

enum TaskType: String, Codable {
    case share = "share"
    case advertise = "advertise"
    case battery = "battery"
    case bottle = "bottle"
    case can = "can"
    case cup = "cup"
}

struct ActiveTime: Codable {
    var startTime:String?
    var endTime:String?
    
    enum CodingKeys:String, CodingKey {
        case startTime = "startTime"
        case endTime = "endTime"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        startTime = try? container.decodeIfPresent(String.self, forKey: .startTime)
        endTime = try? container.decodeIfPresent(String.self, forKey: .endTime)
    }
}

struct TaskReward: Codable {
    var type:TaskRewardType?
    var amount:Int?
    var rewardTime:String?
    var rightIcon:String?
    var ttl:Int64?
    var remainingQuantity:Int?
    var description:String?
    var picture:String?
    var total:String?
    var expire:String?
    var name:String?
    var end:String?
    var category:String?
    var notice:String?
    
    enum CodingKeys:String, CodingKey {
        case type = "type"
        case amount = "amount"
        case rewardTime = "rewardTime"
        case rightIcon = "rightIcon"
        case ttl = "ttl"
        case remainingQuantity = "remainingQuantity"
        case description = "description"
        case picture = "picture"
        case total = "total"
        case expire = "expire"
        case name = "name"
        case end = "end"
        case category = "category"
        case notice = "notice"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try? container.decodeIfPresent(TaskRewardType.self, forKey: .type)
        amount = try? container.decodeIfPresent(Int.self, forKey: .amount)
        rewardTime = try? container.decodeIfPresent(String.self, forKey: .rewardTime)
        rightIcon = try? container.decodeIfPresent(String.self, forKey: .rightIcon)
        ttl = try? container.decodeIfPresent(Int64.self, forKey: .ttl)
        remainingQuantity = try? container.decodeIfPresent(Int.self, forKey: .remainingQuantity)
        description = try? container.decodeIfPresent(String.self, forKey: .description)
        picture = try? container.decodeIfPresent(String.self, forKey: .picture)
        total = try? container.decodeIfPresent(String.self, forKey: .total)
        expire = try? container.decodeIfPresent(String.self, forKey: .expire)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
        end = try? container.decodeIfPresent(String.self, forKey: .end)
        category = try? container.decodeIfPresent(String.self, forKey: .category)
        notice = try? container.decodeIfPresent(String.self, forKey: .notice)
    }
}

enum TaskRewardType: String, Codable {
    case point = "point"
    case coupons = "coupons"
    case lottery = "lottery"
}

struct TaskStatusRequest: Codable {
    var createTime:String
}

struct TaskResponseStatus: Codable {
    var message:String?
    var status:TaskStatus?
    
    enum CodingKeys:String, CodingKey {
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try? container.decodeIfPresent(String.self, forKey: .message)
        status = try? container.decodeIfPresent(TaskStatus.self, forKey: .status)
    }
}

enum TaskStatus: String, Codable {
    case success = "success"
    case failure = "failure"
}

struct FinishTaskInfo:Codable {
    var createTime:String
    var type:String
}

//struct TaskStatus: Codable{
//    var type:TaskType
//    var finishTime:String
//    var createTime:String
//}
//
//
//enum TaskType:String, Codable {
//    case AD = "advertise"
//    case battery = "battery"
//    case share = "share"
//    case bottle = "bottle"
//}
//
//
//struct FinishTaskInfo:Codable {
//    var questCreateTime:String
//    var questType:String
//}
