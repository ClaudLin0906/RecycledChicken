//
//  HomeModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/25.
//

import Foundation

struct UseRecordInfo:Decodable {
    var storeName:String
    var time:String
    var battery:Int?
    var bottle:Int?
}
