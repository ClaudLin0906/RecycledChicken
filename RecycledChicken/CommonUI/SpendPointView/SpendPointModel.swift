//
//  SpendPointModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/22.
//

import Foundation

struct SpendPointInfo:Codable {
    var lotteryItemName:String
    var lotteryItemCreateTime:String
    var count:Int
    var totalPoint:String
}

enum SpendPointType {
    case CommodityVoucher
    case Lottery
}


func spendPointAction(_ info: SpendPointInfo, completion: @escaping (Data?, Int?, String?) -> Void){
    let spendPointInfoDic = try? info.asDictionary()
    NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.buyLottery, parameters: spendPointInfoDic, AuthorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
        completion(data, statusCode, errorMSG)
    }
}
