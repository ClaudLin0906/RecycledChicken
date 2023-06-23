//
//  RecycleLogModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/23.
//

import Foundation

struct RecycleLogInfo: Decodable {
    var storeID:String
    var time:String
}

struct InfoTime {
    var year:Int
    var month:Int
    var day:Int
}
