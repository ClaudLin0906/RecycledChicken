//
//  Common.swift
//  RecycledChickenSwiftUI
//
//  Created by 林書郁 on 2024/1/9.
//

import Foundation
import UIKit

struct APIUrl {
    static let domainName = "https://useries.buenooptics.com:8443/app"
    static let register = "/regist"
    static let login = "/login"
    static let changePWD = "/reset"
    static let smsCode = "/smsCode"
    static let useRecord = "/useRecord"
    static let tradeRecord = "/tradeRecord"
    static let machineStatus = "/machineStatus"
    static let buyLottery = "/buyLottery"
    static let checkLotteryItem = "/checkLotteryItem"
    static let checkLotteryRecord = "/checkLotteryRecord"
    static let searchUserData = "/searchUserData"
    static let updateProfile = "/updateProfile"
    static let sendEmail = "/sendEmail"
    static let getQuestList = "/getQuestList"
    static let forgotPassword = "/forgotPassword"
    static let smsCertificate = "/smsCertificate"
    static let getAd = "/getAd"
    static let getNotification = "/getNotification"
    static let quest = "/quest"
    static let getQuestStatus = "/getQuestStatus"
    static let taskAD = "https://www.buenopartners.com.tw/recyclepunk"
    static let delete = "/delete"
}

func validateCellPhone(text:String) -> Bool{
    let mobileReg = "^09\\d{8}$"
    let resgextestMobile = NSPredicate(format: "SELF MATCHES %@", mobileReg).evaluate(with: text)
    return resgextestMobile
}

func getDayOfTheWeek() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE"
    return dateFormatter.string(from: Date())
}

func getDates(i: Int, currentDate:Date, dateformat:(String,String) = ("yyyy-MM-dd","EEE")) -> (String, String, Date){
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US")
    var date = currentDate
    let cal = Calendar.current
    date = cal.date(byAdding: .day, value: i, to: date)!
    dateFormatter.dateFormat = dateformat.0
    let stringFormate1 = dateFormatter.string(from: date)
    dateFormatter.dateFormat = dateformat.1
    let stringFormate2 = dateFormatter.string(from: date)
    return (stringFormate1, stringFormate2, date)
}
