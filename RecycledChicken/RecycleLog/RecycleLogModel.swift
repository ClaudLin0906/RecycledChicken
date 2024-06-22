//
//  RecycleLogModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/23.
//

import Foundation

struct RecycleLogInfo:Codable {
    var time:Date
    var battery:Int = 0
    var bottle:Int = 0
    var colorlessBottle:Int = 0
    var coloredBottle:Int = 0
    var can:Int = 0
}


