//
//  HomeModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/25.
//

import Foundation

struct ADBannerInfo: Codable {
    var image: String?
    var URL: String?
}

struct ItemInfo: Codable {
    var productImage: String?
    var productName: String?
    var description: String?
    var productLink: String?
}
