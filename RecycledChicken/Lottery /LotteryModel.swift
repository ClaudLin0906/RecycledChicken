//
//  LotteryModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/16.
//

import Foundation

struct LotteryInfo: Decodable {
    var itemPrice:Int
    var purchaserCount:Int
    var activityEndTime:String
    var activityStartTime:String
    var lotteryDrawDate:String
    var createTime:String
    var picture:String
    var pictureBig:String
    var itemName:String
}

var LotterySegmentedControlTitles = ["抽獎卷", "活動獎勵", "合作商家"]
