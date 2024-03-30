//
//  MyTickertModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/22.
//

import Foundation

struct MyTickertInfo:Decodable {
    var itemName:String
    var UUID:String
    var buyTime:String
    var activityStartTime:String
    var activityEndTime:String
    var lotteryDrawDate:String
}


var MyTickertTitles = ["抽獎劵", "商品劵"]
