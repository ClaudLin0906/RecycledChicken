//
//  StoreMapModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/23.
//

import Foundation

struct MapInfo: Decodable {
    var storeName:String
    var cellPath:String
    var remainingProcessable:remainingProcessableInfo
    var status:String
}

struct remainingProcessableInfo: Decodable{
    var bottle:Int
    var battery:Int
}
