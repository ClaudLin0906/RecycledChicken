//
//  CustomCalenderModel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/27.
//

import Foundation


class CustomCalenderModel {
    static let shared = CustomCalenderModel()
    var selectedDate:String = getDates(i: 0, currentDate: Date()).0
}
