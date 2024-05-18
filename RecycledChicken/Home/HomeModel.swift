//
//  HomeModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/25.
//

import Foundation

struct ADBannerInfo: Codable {
    var image:String?
    var URL:String?
    
    enum CodingKeys:String, CodingKey {
        case image = "image"
        case URL = "URL"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        image = try? container.decodeIfPresent(String.self, forKey: .image)
        URL = try? container.decodeIfPresent(String.self, forKey: .URL)
    }
}

struct ItemInfo: Codable {
    
    var productImage:String?
    var productName:String?
    var description:String?
    var productLink:String?
    
    enum CodingKeys:String, CodingKey {
        case productImage = "productImage"
        case productName = "productName"
        case description = "description"
        case productLink = "productLink"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        productImage = try? container.decodeIfPresent(String.self, forKey: .productImage)
        productName = try? container.decodeIfPresent(String.self, forKey: .productName)
        description = try? container.decodeIfPresent(String.self, forKey: .description)
        productLink = try? container.decodeIfPresent(String.self, forKey: .productLink)
    }
}
