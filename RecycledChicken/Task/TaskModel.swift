//
//  TaskModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/16.
//

import Foundation

struct TaskInfo: Decodable, CustomStringConvertible{
    var startTime:String
    var count:Int
    var endTime:String
    var createTime:String
    var description:String
    var point:Int
    var type:TaskType
    var isFinish:Bool?
}

struct TaskStatus: Decodable{
    var type:TaskType
    var finishTime:String
    var createTime:String
}


enum TaskType:String, Decodable {
    case AD = "advertise"
    case battery = "battery"
    case share = "share"
    case bottle = "bottle"
}


struct FinishTaskInfo:Codable {
    var questCreateTime:String
    var questType:String
}
