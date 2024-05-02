//
//  StoreMapModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/23.
//

import Foundation

struct MapInfo: Codable {
    var isVisible:Bool?
    var storeName:String
    var storeID:String
    var cellPath:String
    var remainingProcessable:RemainingProcessableInfo
    var status:String
    var storeAddress:String
    var coordinate:String
    var disance:Double = 0
}

struct RemainingProcessableInfo: Codable {
    var bottle:Int?
    var battery:Int?
}

