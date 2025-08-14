//
//  SpendPointModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/22.
//

import Foundation

struct SpendPointInfo:Codable {
    var name:String
    var createTime:String
    var count:Int
    var totalPoint:String
}

enum SpendPointType {
    case CommodityVoucher
    case Lottery
}

struct SpendPointResponse:Codable {
    var reuslt:String?
    var message:String?
    var callTime:String?
    
    enum CodingKeys:String, CodingKey {
        case reuslt = "reuslt"
        case message = "message"
        case callTime = "callTime"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        reuslt = try? container.decodeIfPresent(String.self, forKey: .reuslt)
        message = try? container.decodeIfPresent(String.self, forKey: .message)
        callTime = try? container.decodeIfPresent(String.self, forKey: .callTime)
    }
}


func spendPointAction(_ info: SpendPointInfo, completion: @escaping (Data?, Int?, String?) -> Void){
    let spendPointInfoDic = try? info.asDictionary()
    NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.buyLottery, parameters: spendPointInfoDic, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
        completion(data, statusCode, errorMSG)
    }
}
