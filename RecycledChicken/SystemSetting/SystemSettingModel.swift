//
//  SystemSettingModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import Foundation
import UIKit

struct switchTableViewInfo {
    var title:String
    var isTrue:Bool
}

struct accountTableViewInfo {
    var title:String
    var inviteInfo:InviteInfo?
}

struct InviteInfo {
    var inviteCode:String
    var isInvite:Bool
}


struct InviteRequestInfo:Codable {
    var inviteCode:String
}
