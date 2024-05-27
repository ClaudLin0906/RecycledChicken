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
    var sites:[String]?
    
    enum CodingKeys:String, CodingKey {
        case createTime = "createTime"
        case startTime = "startTime"
        case endTime = "endTime"
        case title = "title"
        case description = "description"
        case type = "type"
        case reward = "reward"
        case iconUrl = "iconUrl"
        case sites = "sites"
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
        sites = try? container.decodeIfPresent([String].self, forKey: .sites)
    }
//    var startTime:String
//    var count:Int
//    var endTime:String
//    var createTime:String
//    var description:String
//    var point:Int
//    var type:TaskType
//    var isFinish:Bool?
//    var url:String?
}

enum TaskType: String, Codable {
    case share = "share"
    case advertise = "advertise"
    case recycling = "recycling"
}

struct TaskReward: Codable {
    var type:TaskRewardType?
    var requiredAmount:Int?
    var rewardTime:String?
    var leftIcon:String?
    var rightIcon:String?
}

enum TaskRewardType: String, Codable {
    case point = "point"
    case ticket = "ticket"
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
