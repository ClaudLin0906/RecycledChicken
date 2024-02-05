//
//  HomeModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/25.
//

import Foundation

enum RecyceledSort: CaseIterable {
    case bottle
    case battery
    case papperCub
    case aluminumCan
    
    func getInfo() -> RecyceledSortInfo {
        switch self {
        case .bottle:
            return RecyceledSortInfo(chineseName: "寶特瓶", englishName: "PET", iconName: "pet")
        case .battery:
            return RecyceledSortInfo(chineseName: "電池", englishName: "BATTERY", iconName: "battery")
        case .papperCub:
            return RecyceledSortInfo(chineseName: "紙杯", englishName: "PAPPERCUB", iconName: "papperCub")
        case .aluminumCan:
            return RecyceledSortInfo(chineseName: "鋁罐", englishName: "ALUMINUM CAN", iconName: "aluminumCan")
        }
    }
    
}

struct RecyceledSortInfo {
    var chineseName: String
    var englishName: String
    var iconName: String
}


