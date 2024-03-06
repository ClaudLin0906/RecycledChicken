//
//  IllustratedGuideModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/25.
//

import Foundation
import UIKit

struct IllustratedGuide {
    var isLock:Bool = true
    var name:String
    var title:String
    var image:UIImage
    var guide:String
}

var illustratedGuideModelDatas:[IllustratedGuide] =
    [
        IllustratedGuide(isLock: false, name: "碳員", title: "新手碳教學", image: UIImage(named: "chi-15 1")!, guide: "123456678901234566789012345667890123456678901234566789012345667890123456678901234566789012345667890123456678901234566789012345667890123456678901234566789012345667890123456678901234566789012345667890123456678901234566789012345667890123456678901234566789012345667890123456678901234566789012345667890")
    ]
