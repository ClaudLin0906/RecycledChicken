//
//  HomeModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/25.
//

import Foundation

enum RecyceledSort {
    case bottle
    case battery
    case papperCub
    case aluminumCan
}

struct RecyceledSortInfo {
    var chineseName: String
    var englishName: String
    var iconName: String
    var count: Int
    var sort:RecyceledSort
}

