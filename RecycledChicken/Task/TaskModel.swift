//
//  TaskModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/16.
//

import Foundation

struct TaskInfo: Decodable {
    var startTime:String
    var count:Int
    var endTime:String
    var createTime:String
    var description:String
    var point:Int
    var type:TaskType
}


enum TaskType:String, Decodable {
    case AD = "advertise"
    case battery = "battery"
    case share = "share"
    case bottle = "bottle"
}
