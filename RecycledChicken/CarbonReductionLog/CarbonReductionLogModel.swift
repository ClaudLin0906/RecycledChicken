//
//  CarbonReductionLogModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/26.
//

import Foundation
import UIKit

protocol ColorFillTypeDelegate {
    func tapImage(_ imageView:UIImageView, userdefultKey:String, colorFillView:ColorFillView)
    func tapBackground(_ backgroundView:UIView, userdefultKey:String, colorFillView:ColorFillView)
}

enum Notch: Int, CaseIterable {
    case minimum, medium, maximum
}

enum ColorFillView {
    case ColorFillTypeOneView
    case ColorFillTypeTwoView
    case ColorFillTypeThreeView
    case ColorFillTypeFourView
}

struct ChooseObject {
    var imageView:UIImageView?
    var backgroundView:UIView?
    var userdefultKey:String
}

struct CarbonReductionLogInfo: Codable {
    var personalRecycleAmountAndTarget:[PersonalRecycleAmountAndTargetInfo]?
    var fix:FixInfo?
    
    enum CodingKeys:String, CodingKey {
        case personalRecycleAmountAndTarget = "personalRecycleAmountAndTarget"
        case fix = "fix"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        personalRecycleAmountAndTarget = try? container.decodeIfPresent([PersonalRecycleAmountAndTargetInfo].self, forKey: .personalRecycleAmountAndTarget)
        fix = try? container.decodeIfPresent(FixInfo.self, forKey: .fix)
    }
}

struct PersonalRecycleAmountAndTargetInfo: Codable  {
    
    var itemName:String?
    var target:Int?
    var totalRecycled:Int?
    var conversionRate:Double?
    var infoLink:String?
    
    enum CodingKeys:String, CodingKey {
        case itemName = "itemName"
        case target = "target"
        case totalRecycled = "totalRecycled"
        case conversionRate = "conversionRate"
        case infoLink = "infoLink"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        itemName = try? container.decodeIfPresent(String.self, forKey: .itemName)
        target = try? container.decodeIfPresent(Int.self, forKey: .target)
        totalRecycled = try? container.decodeIfPresent(Int.self, forKey: .totalRecycled)
        conversionRate = try? container.decodeIfPresent(Double.self, forKey: .conversionRate)
        infoLink = try? container.decodeIfPresent(String.self, forKey: .infoLink)
    }
    
    func getColorRecycledValue() -> CGFloat {
        var result:CGFloat = 0
        switch itemName {
        case "寶特瓶":
            result = 1260
        case "電池":
            result = 182000
        case "鋁罐":
            result = 120100
        case "紙杯":
            result = 9060
        default :
            break
        }
        return result
    }
}

struct FixInfo: Codable  {
    
    var images:[String]?
    var convetValue:Int?
    
    enum CodingKeys:String, CodingKey {
        case images = "images"
        case convetValue = "convetValue"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        images = try? container.decodeIfPresent([String].self, forKey: .images)
        convetValue = try? container.decodeIfPresent(Int.self, forKey: .convetValue)
    }
}
