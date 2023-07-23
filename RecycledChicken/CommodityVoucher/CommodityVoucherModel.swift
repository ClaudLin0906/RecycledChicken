//
//  CommodityVoucherModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/23.
//

import Foundation

struct CommodityVoucherInfo: Decodable {
    var itemPrice:Int
    var purchaserCount:Int
    var activityEndTime:String
    var activityStartTime:String
    var createTime:String
    var picture:String
    var pictureBig:String
    var itemName:String
}
