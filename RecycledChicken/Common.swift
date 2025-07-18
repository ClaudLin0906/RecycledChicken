//
//  Common.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import Foundation
import UIKit
import UserNotifications
import FirebaseMessaging

class Setting {
    static let shared = Setting()
    var language:Language? = getLanguage()
}

func getLanguage() -> Language? {
    if let appleLanguagesArr = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String] {
        let appleLanguages = appleLanguagesArr[0]
        return Language(rawValue: appleLanguages)
    }
    return nil
}

func forcedConversionLanguage(_ vc:UIViewController, _ language:Language) {
    guard getLanguage() != language else { return }
    let action = UIAlertAction(title: "confirm".localized, style: .default) { _ in
        setLanguage(language)
        localNotifications("appClose".localized, "tapOpenApp".localized)
        exit(2)
    }
    showAlert(VC: vc, title: "forcedConversion".localized, alertAction: action)
}

func setLanguage(_ language:Language) {
    var languages = Language.allCases.filter({return language != $0 })
    languages.insert(language, at: 0)
    let languageStrs = languages.map({$0.rawValue})
    UserDefaults.standard.set(languageStrs, forKey: "AppleLanguages")
}

func localNotifications(_ title:String, _ body:String) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.default
    let tigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: tigger)
    UNUserNotificationCenter.current().add(request) { error in
        guard error == nil else {
            print(error?.localizedDescription)
            return
        }
    }
}

func convertWeight(_ value: Double, to targetUnit: WeightUnit = .gram) -> (convertedValue: Double, unit: WeightUnit) {
    var resultValue: Double
    var resultUnit: WeightUnit
    
    if value >= 1000 {
        if value >= 1000_000 {
            resultValue = value / 1000_000
            resultUnit = .tonne
        }else {
            resultValue = value / 1000
            resultUnit = .kilogram
        }
    }else{
        resultValue = value
        resultUnit = .gram
    }
    return (resultValue, resultUnit)
}

enum Language:String, CaseIterable {
    case traditionalChinese = "zh-Hant-TW"
    case english = "en-TW"
}

func getChickenLevel() -> IllustratedGuideModelLevel {
    return CurrentUserInfo.shared.currentProfileNewInfo?.levelInfo?.chickenLevel ?? .one
}

struct IllustratedGuide {
    var level:Int
    var levelImage:UIImage
    var iconImage:UIImage
    var guideImage:UIImage
    var guideBackgroundImage:UIImage
    var name:String
    var title:String
    var guide:String
    var discover:String
    var ability:String
    var experience:String
    var attack:String
}

enum IllustratedGuideModelLevel:Int, CaseIterable, Codable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
}

func getIllustratedGuide(_ illustratedGuideModelLevel: IllustratedGuideModelLevel) -> IllustratedGuide {
    switch illustratedGuideModelLevel {
    case .one:
        return IllustratedGuide(level: 1, levelImage: UIImage(named:"level1")!, iconImage: UIImage(named:"level1-icon")!, guideImage: UIImage(named: "level1-guide")!, guideBackgroundImage: UIImage(named: "level1-guideBackground")!, name: "illustratedGuideOneOfName".localized, title: "illustratedGuideOneOfTitle".localized, guide: "illustratedGuideOneOfGuide".localized, discover: "", ability: "5056", experience: "0", attack: "物理攻擊")
    case .two:
        return IllustratedGuide(level: 2, levelImage: UIImage(named:"level2")!, iconImage: UIImage(named: "level2-icon")!, guideImage: UIImage(named: "level2-guide")!, guideBackgroundImage: UIImage(named: "level2-guideBackground")!, name: "illustratedGuideTwoOfName".localized, title: "illustratedGuideTwoOfTitle".localized, guide: "illustratedGuideTwoOfGuide".localized, discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "7424", experience: "10000", attack: "治癒")
    case .three:
        return IllustratedGuide(level: 3, levelImage: UIImage(named:"level3")!, iconImage: UIImage(named: "level3-icon")!, guideImage: UIImage(named: "level3-guide")!, guideBackgroundImage: UIImage(named: "level3-guideBackground")!, name: "illustratedGuideThreeOfName".localized, title: "illustratedGuideThreeOfTitle".localized, guide: "illustratedGuideThreeOfGuide".localized, discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "1800", experience: "20000", attack: "魔性攻擊")
    case .four:
        return IllustratedGuide(level: 4, levelImage: UIImage(named:"level4")!, iconImage: UIImage(named: "level4-icon")!, guideImage: UIImage(named: "level4-guide")!, guideBackgroundImage: UIImage(named: "level4-guideBackground")!, name: "illustratedGuideFourOfName".localized, title: "illustratedGuideFourOfTitle".localized, guide: "illustratedGuideFourOfGuide".localized, discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "7130", experience: "30000", attack: "魔性攻擊")
    case .five:
        return IllustratedGuide(level: 5, levelImage: UIImage(named:"level5")!, iconImage: UIImage(named: "level5-icon")!, guideImage: UIImage(named: "level5-guide")!, guideBackgroundImage: UIImage(named: "level5-guideBackground")!, name: "illustratedGuideFiveOfName".localized, title: "illustratedGuideFiveOfTitle".localized, guide: "illustratedGuideFiveOfGuide".localized, discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "2500", experience: "40000", attack: "防禦")
    case .six:
        return IllustratedGuide(level: 6, levelImage: UIImage(named:"level6")!, iconImage: UIImage(named: "level6-icon")!, guideImage: UIImage(named: "level6-guide")!, guideBackgroundImage: UIImage(named: "level6-guideBackground")!, name: "illustratedGuideSixOfName".localized, title: "illustratedGuideSixOfTitle".localized
                                , guide: "illustratedGuideSixOfGuide".localized, discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "63", experience: "50000", attack: "物理攻擊")
    case .seven:
        return IllustratedGuide(level: 7, levelImage: UIImage(named:"level7")!, iconImage: UIImage(named: "level7-icon")!, guideImage: UIImage(named: "level7-guide")!, guideBackgroundImage: UIImage(named: "level7-guideBackground")!, name: "illustratedGuideSevenOfName".localized, title: "illustratedGuideSevenOfTitle".localized, guide: "illustratedGuideSevenOfGuide".localized, discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "2013", experience: "60000", attack: "魔性攻擊")
    case .eight:
        return IllustratedGuide(level: 8, levelImage: UIImage(named:"level8")!, iconImage: UIImage(named: "level8-icon")!, guideImage: UIImage(named: "level8-guide")!, guideBackgroundImage: UIImage(named: "level8-guideBackground")!, name: "illustratedGuideEightOfName".localized, title: "illustratedGuideEightOfTitle".localized, guide: "illustratedGuideEightOfGuide".localized, discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "2535", experience: "70000", attack: "物理攻擊")
    case .nine:
        return IllustratedGuide(level: 9, levelImage: UIImage(named:"level9")!, iconImage: UIImage(named: "level9-icon")!, guideImage: UIImage(named: "level9-guide")!, guideBackgroundImage: UIImage(named: "level9-guideBackground")!, name: "illustratedGuideNineOfName".localized, title: "illustratedGuideNineOfTitle".localized, guide: "illustratedGuideNineOfGuide".localized, discover: "感謝你一直努力減少排碳量 泥滑島的碳竹雞們又可以自由在的生活！ 還會遇到誰呢....", ability: "13625", experience: "80000", attack: "治癒")
    case .ten:
        return IllustratedGuide(level: 10, levelImage: UIImage(named:"level10")!, iconImage: UIImage(named: "level10-icon")!, guideImage: UIImage(named: "level10-guide")!, guideBackgroundImage: UIImage(named: "level10-guideBackground")!, name: "illustratedGuideTenOfName".localized, title: "illustratedGuideTenOfTitle".localized, guide: "illustratedGuideTenOfGuide".localized, discover: "各位地球的智慧生命呀 感謝你們一同努力減少排碳量！ 接下來有碳長的帶領 相信我們的世界一定會越來越好", ability: "2190", experience: "90000", attack: "防禦")
    }
}

class CommonColor {
    
    static let shared = CommonColor()
    
    var color1 = #colorLiteral(red: 0.2745098039, green: 0.3764705882, blue: 0.3333333333, alpha: 1)

    var color2 = #colorLiteral(red: 0.937254902, green: 0.9137254902, blue: 0.8156862745, alpha: 1)

    var color3 = #colorLiteral(red: 0.8862745098, green: 0.7607843137, blue: 0.4901960784, alpha: 1)

    var color4 = #colorLiteral(red: 0.9490196078, green: 0.9411764706, blue: 0.9058823529, alpha: 1)

    var color5 = #colorLiteral(red: 0.6862745098, green: 0.5764705882, blue: 0.4431372549, alpha: 1)

    var color6 = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)

    var color7 = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)

    var color8 = #colorLiteral(red: 0.8980392157, green: 0.5333333333, blue: 0.368627451, alpha: 1)

    var color9 = #colorLiteral(red: 0.8274509804, green: 0.6901960784, blue: 0.4156862745, alpha: 1)
    
    var color10 = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        
    var color11 = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 1)
    
}


enum RecyceledSort: CaseIterable {
    
    case bottle
    case battery
    case papperCub
    case aluminumCan
//    case publicTransport
    
    func getInfo() -> RecyceledSortInfo {
        let bottleColor = #colorLiteral(red: 0.8862745098, green: 0.7607843137, blue: 0.4901960784, alpha: 1)
        let batteryColor = #colorLiteral(red: 0.2666666667, green: 0.4901960784, blue: 0.4156862745, alpha: 1)
        let papperCubColor = #colorLiteral(red: 0.6862745098, green: 0.5764705882, blue: 0.4431372549, alpha: 1)
        let aluminumCanColor = #colorLiteral(red: 0.7294117647, green: 0.3607843137, blue: 0.1490196078, alpha: 1)
//        let publicTransportColor = #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1)
        switch self {
        case .bottle:
            return RecyceledSortInfo(chineseName: "bottle".localized, englishName: "PET", iconName: "Pet", color: bottleColor, recycleUnit: "瓶")
        case .battery:
            return RecyceledSortInfo(chineseName: "battery".localized, englishName: "BATTERY", iconName: "battery", color: batteryColor, recycleUnit: "顆")
        case .papperCub:
            return RecyceledSortInfo(chineseName: "papperCup".localized, englishName: "PAPPER CUB", iconName: "papperCub", color: papperCubColor, recycleUnit: "個")
        case .aluminumCan:
            return RecyceledSortInfo(chineseName: "aluminumCan".localized, englishName: "ALUMINUM CAN", iconName: "aluminumCan", color:aluminumCanColor, recycleUnit: "個")
//        case .publicTransport:
//            return RecyceledSortInfo(chineseName: "大眾運輸", englishName: "publicTransport", iconName: "bus", color: publicTransportColor, recycleUnit: "次", oUnit: "gCO2e")
        }
    }
    
}

struct RecyceledSortInfo {
    var chineseName: String
    var englishName: String
    var iconName: String
    var color:UIColor
    var recycleUnit:String
}

enum WeightUnit: String {
    case gram = "gCO₂e"
    case kilogram = "kgCO₂e"
    case tonne = "tCO₂e"
}

var FirstTime = true

var LoginSuccess = false

//let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first

let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).last


class CommonKey {
    static let shared = CommonKey()
    let googleMapKey = "AIzaSyDma1zKcZksbUMQwoSjfWCPfwslnGQoxWo"//廠商
//    let googleMapKey = "AIzaSyCQooOAaz-Lm2IpRZGz26Lx6lTSs9JFvZQ"//Claud
    let ARKey = "EE17C-B311A-5F817-F0AAF-2A914"
    var authToken = ""
}

class KeyChainKey {
    static let shared = KeyChainKey()
    let accountInfo = "accountInfo"
}

class UserDefaultKey {
    static let shared = UserDefaultKey()
    let biometrics = "biometrics"
    let displayToday = "displayToday"
    let colorFillTypeOne = "colorFillTypeOne"
    let colorFillTypeThree = "colorFillTypeThree"
    let colorFillTypeFour = "colorFillTypeFour"
    let colorBottleUseCount = "colorBottleUseCount"
    let colorBatteryUseCount = "colorBatteryUseCount"
    let colorPapperCubUseCount = "colorPapperCubUseCount"
    let colorAluminumCanUseCount = "colorAluminumCanUseCount"
    let oneCellViewImageViewOfColorFillTypeOneView = "oneCellViewImageViewOfColorFillTypeOneView"
    let oneCellViewBackgroundOfColorFillTypeOneView = "oneCellViewBackgroundOfColorFillTypeOneView"
    let twoCellViewImageViewOfColorFillTypeOneView = "twoCellViewImageViewOfColorFillTypeOneView"
    let twoCellViewBackgroundOfColorFillTypeOneView = "twoCellViewBackgroundOfColorFillTypeOneView"
    let threeCellViewImageViewOfColorFillTypeOneView = "threeCellViewImageViewOfColorFillTypeOneView"
    let threeCellViewBackgroundOfColorFillTypeOneView = "threeCellViewBackgroundOfColorFillTypeOneView"
    let fourCellViewImageViewOfColorFillTypeOneView = "fourCellViewImageViewOfColorFillTypeOneView"
    let fourCellViewBackgroundOfColorFillTypeOneView = "fourCellViewBackgroundOfColorFillTypeOneView"
    let fiveCellViewImageViewOfColorFillTypeOneView = "fiveCellViewImageViewOfColorFillTypeOneView"
    let fiveCellViewBackgroundOfColorFillTypeOneView = "fiveCellViewBackgroundOfColorFillTypeOneView"
    let sixCellViewImageViewOfColorFillTypeOneView = "sixCellViewImageViewOfColorFillTypeOneView"
    let sixCellViewBackgroundOfColorFillTypeOneView = "sixCellViewBackgroundOfColorFillTypeOneView"
    let sevenCellViewImageViewOfColorFillTypeOneView = "sevenCellViewImageViewOfColorFillTypeOneView"
    let sevenCellViewBackgroundOfColorFillTypeOneView = "sevenCellViewBackgroundOfColorFillTypeOneView"
    let eightCellViewImageViewOfColorFillTypeOneView = "eightCellViewImageViewOfColorFillTypeOneView"
    let eightCellViewBackgroundOfColorFillTypeOneView = "eightCellViewBackgroundOfColorFillTypeOneView"
    let nineCellViewImageViewOfColorFillTypeOneView = "nineCellViewImageViewOfColorFillTypeOneView"
    let nineCellViewBackgroundOfColorFillTypeOneView = "nineCellViewBackgroundOfColorFillTypeOneView"
    let backgroundOfColorFillTypeTwoView = "backgroundOfColorFillTypeTwoView"
    let bigFillRightChickenOfColorFillTypeTwoView = "bigFillRightChickenOfColorFillTypeTwoView"
    let medFillRightChickenOfFillTypeTwoView = "medFillRightChickenOfFillTypeTwoView"
    let smallFillRightChickenOfFillTypeTwoView = "smallFillRightChickenOfFillTypeTwoView"
    let bottomFillRightChickenOfColorFillTypeTwoView = "bottomFillRightChickenOfColorFillTypeTwoView"
    let fillColorBatteryOfColorFillTypeTwoView = "fillColorBatteryOfColorFillTypeTwoView"
    let fillColorPaperCupOfColorFillTypeTwoView = "fillColorPaperCupOfColorFillTypeTwoView"
    let fillColoraluminumCanOfColorFillTypeTwoView = "fillColoraluminumCanOfColorFillTypeTwoView"
    let fillColorBigPETOfColorFillTypeTwoView = "fillColorBigPETOfColorFillTypeTwoView"
    let backgroundOfColorFillTypeThreeView = "backgroundOfColorFillTypeThreeView"
    let bigFillRightChickenOfColorFillTypeThreeView = "bigFillRightChickenOfColorFillTypeThreeView"
    let leftTopOneFillRightChickenOfColorFillTypeThreeView = "leftTopOneFillRightChickenOfColorFillTypeThreeView"
    let leftTopTwoFillRightChickenOfColorFillTypeThreeView = "leftTopTwoFillRightChickenOfColorFillTypeThreeView"
    let leftTopThreeFillRightChickenOfColorFillTypeThreeView = "leftTopThreeFillRightChickenOfColorFillTypeThreeView"
    let leftTopFourFillRightChickenOfColorFillTypeThreeView = "leftTopFourFillRightChickenOfColorFillTypeThreeView"
    let leftBottomOneFillRightChickenOfColorFillTypeThreeView = "leftBottomOneFillRightChickenOfColorFillTypeThreeView"
    let leftBottomTwoFillRightChickenOfColorFillTypeThreeView = "leftBottomTwoFillRightChickenOfColorFillTypeThreeView"
    let leftBottomThreeFillRightChickenOfColorFillTypeThreeView = "bigFillRightChickenOfColorFillTypeThreeView"
    let leftBottomFourFillRightChickenOfColorFillTypeThreeView = "leftBottomFourFillRightChickenOfColorFillTypeThreeView"
    let rightBottomOneFillLeftChickenOfColorFillTypeThreeView = "rightBottomOneFillLeftChickenOfColorFillTypeThreeView"
    let rightBottomTwoFillRightChickenOfColorFillTypeThreeView = "rightBottomTwoFillRightChickenOfColorFillTypeThreeView"
    let rightBottomThreeFillRightChickenOfColorFillTypeThreeView = "rightBottomThreeFillRightChickenOfColorFillTypeThreeView"
    let rightBottomFourFillRightChickenOfColorFillTypeThreeView = "rightBottomFourFillRightChickenOfColorFillTypeThreeView"
    let backgroundOfColorFillTypeFourView = "backgroundOfColorFillTypeFourView"
    let bigFillRightChickenOfColorFillTypeFourView = "bigFillRightChickenOfColorFillTypeFourView"
    let bigFillLeftChickenOfColorFillTypeFourView = "bigFillLeftChickenOfColorFillTypeFourView"
    let oneFillRightChickenOfColorFillTypeFourView = "oneFillRightChickenOfColorFillTypeFourView"
    let twoFillRightChickenOfColorFillTypeFourView = "twoFillRightChickenOfColorFillTypeFourView"
    let threeFillRightChickenOfColorFillTypeFourView = "threeFillRightChickenOfColorFillTypeFourView"
    let isFirstProduct = "isFirstProduct"
    let oldChickenLevel = "oldChickenLevel"
    let finishTasks = "finishTasks"
    let receiveTasks = "receiveTasks"
    let isSubscribed = "isSubscribed"
    let colorFillTypeOneViewCo2Value = "colorFillTypeOneViewCo2Value"
    let colorFillTypeTwoViewCo2Value = "colorFillTypeTwoViewCo2Value"
    let colorFillTypeThreeViewCo2Value = "colorFillTypeThreeViewCo2Value"
    let colorFillTypeFourViewCo2Value = "colorFillTypeFourViewCo2Value"
}

class CurrentUserInfo {
    
    static let shared = CurrentUserInfo()
    
    var currentAccountInfo:AccountInfo = {
        if let jsonData = KeychainService.shared.loadJsonDataFromKeychain(account: KeyChainKey.shared.accountInfo), let accountInfo = try? JSONDecoder().decode(AccountInfo.self, from: jsonData) {
            return accountInfo
        }else {
            return AccountInfo(userPhoneNumber: "", userPassword: "")
        }
    }()
    
    var currentProfileInfo:ProfileNewInfo?
    {
        willSet{
            if let newValue = newValue, newValue.userPhoneNumber == "0000000000" {
                isGuest = true
            }else{
                isGuest = false
            }
        }
    }
    
    var currentProfileNewInfo:ProfileNewInfo?
    {
        willSet{
            if let newValue = newValue, newValue.userPhoneNumber == "0000000000" {
                isGuest = true
            }else{
                isGuest = false
            }
        }
    }
    
    var isGuest = false
}

class GuestInfo {
    
    static let shared = GuestInfo()
    
    var guestAccount = "0000000000"
    
    var guestPassword = "0000000000"
    
}

struct APIUrl {
    static let domainName = "https://useries.buenooptics.com:8443/app/v2"
    static let buenopartners = "https://www.buenopartners.com.tw/formula"
    static let register = "/auth/register"
    static let login = "/auth/login"
    static let changePWD = "/reset"
    static let smsCode = "/auth/generateSmsCode"
    static let useRecord = "/useRecord"
    static let tradeRecord = "/tradeRecord"
    static let machineStatus = "/machine/status"
    static let buyLottery = "/buyLottery"
    static let checkLotteryItem = "/lottery/items"
    static let checkLotteryRecord = "/checkLotteryRecord"
    static let searchUserData = "/searchUserData"
    static let updateProfile = "/user/profile"
    static let sendEmail = "/sendEmail"
    static let getQuestList = "/getQuestList"
    static let forgotPassword = "/auth/forgotPassword"
    static let smsCertificate = "/smsCertificate"
    static let getAd = "/getAd"
    static let getNotification = "/getNotification"
    static let quest = "/quest"
    static let getQuestStatus = "/getQuestStatus"
    static let taskAD = "https://www.buenopartners.com.tw/recyclepunk"
    static let delete = "/delete"
    static let siteList = "https://www.buenopartners.com.tw/list"
    static let siteListEnglish = "https://www.buenopartners.com.tw/en/list"
    static let mall = "https://www.buenocoop.com/"
    static let getAdBanner = "/ad/banner"
    static let profile = "/user/profile"
    static let items = "/shop/items"
    static let records = "/recycle/records"
    static let pointRecords = "/point/records"
    static let carbonReductionRecords = "/recycle/carbonReductionRecords"
    static let ticketCoupons = "/coupons?category=ticket"
    static let eventCoupons = "/coupons?category=event"
    static let partnerCoupons = "/coupons?category=partner"
    static let questComplete = "/quest/complete"
    static let message = "/message"
    static let lotteryBuy = "/lottery/buy"
    static let couponsBuy = "/coupons/buy"
    static let messageDelete = "/message/delete"
    static let havingLottery = "/lottery/bought"
    static let havingCoupons = "/coupons/bought"
    static let enterActivityCode = "/user/enterActivityCode"
    static let enterInviteCode = "/user/enterInviteCode"
    static let getPopBanner = "/ad/popup"
    static let appleStoreID = "6449214570"
    static let connectAppleStore = "itms-apps://itunes.apple.com/app/\(appleStoreID)"
    static let checkAppleStoreVersion = "https://itunes.apple.com/tw/lookup?id=\(appleStoreID)"
    static let uiPoint = "/ui/point"
}

struct WebViewUrl {
    static let PrivacyPolicyURL = "https://www.buenopartners.com.tw/privacy"
    static let CommonPronblemURL = "https://www.buenopartners.com.tw/faq"
    static let CustomerContactURL = "https://www.buenopartners.com.tw/fae"
    static let ConnectCompanyURL = "https://www.buenopartners.com.tw/contact"
}

var attributes: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.font: UIFont(name: "GenJyuuGothic-Medium", size: 17)!,
    NSAttributedString.Key.foregroundColor: UIColor.white,
    NSAttributedString.Key.kern: 5 // 設定字距
]

let attributes2: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.font: UIFont(name: "GenJyuuGothic-Medium", size: 17)!,
//    NSAttributedString.Key.foregroundColor: UIColor.black,
    NSAttributedString.Key.kern: 5 // 設定字距
]

public class CommonUserDefaultsKey {
    static let removeBackground = "removeBackground"
}

protocol NibOwnerLoadable: AnyObject {
    static var nib: UINib { get }
}

func getRecords(_ sites:[String]? = nil, _ startTime:String, _ endTime:String, completion: @escaping (_ statusCode:Int?, _ errorMSG:String?,  _ useRecordInfos:[UseRecordInfo]?, _ battery:Int?, _ bottle:Int?, _ colorledBottle:Int?, _ colorlessBottle:Int?, _ can:Int?, _ cup:Int?) -> Void){
    guard !CommonKey.shared.authToken.isEmpty else { return }
    var urlStr = APIUrl.domainName + APIUrl.records + "?startTime=\(startTime)T00:00:00.000+08:00&endTime=\(endTime)T23:59:59.999+08:00"
    if let sites = sites {
        let sitesStr = sites.joined(separator: ",")
        urlStr = APIUrl.domainName + APIUrl.records + "?startTime=\(startTime)T00:00:00.000+08:00&endTime=\(endTime)T23:59:59.999+08:00&sites=\(sitesStr)"
    }
    print(urlStr)
    NetworkManager.shared.getJSONBody(urlString: urlStr, authorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
        guard let data = data, statusCode == 200 else {
            completion(statusCode, errorMSG, nil, nil, nil, nil, nil, nil, nil)
            return
        }
        if let useRecordInfos = try? JSONDecoder().decode([UseRecordInfo].self, from: data) {
            var batteryInt:Int?
            var bottleInt:Int?
            var colorledBottleInt:Int?
            var colorlessBottleInt:Int?
            var canInt:Int?
            var cupInt:Int?
            useRecordInfos.forEach { useRecordInfo in
                if let recycleDetails = useRecordInfo.recycleDetails {
                    if let battery = recycleDetails.battery {
                        batteryInt = batteryInt ?? 0
                        batteryInt! += battery
                    }
                    if let bottle = recycleDetails.bottle {
                        bottleInt = bottleInt ?? 0
                        bottleInt! += bottle
                    }
                    if let coloredBottle = recycleDetails.coloredBottle {
                        colorledBottleInt = colorledBottleInt ?? 0
                        colorledBottleInt! += coloredBottle
                    }
                    if let colorlessBottle = recycleDetails.colorlessBottle {
                        colorlessBottleInt = colorlessBottleInt ?? 0
                        colorlessBottleInt! += colorlessBottle
                    }
                    if let can = recycleDetails.can {
                        canInt = canInt ?? 0
                        canInt! += can
                    }
                    if let cup = recycleDetails.cup {
                        cupInt = cupInt ?? 0
                        cupInt! += cup
                    }
                }
            }
            completion(statusCode, errorMSG, useRecordInfos, batteryInt, bottleInt, colorledBottleInt, colorlessBottleInt, canInt, cupInt)
        }
    }
}

func loginOutRemoveObject(){
    CurrentUserInfo.shared.currentProfileNewInfo = nil
    CommonKey.shared.authToken = ""
    LoginSuccess = false
    FirstTime = true
    removeBiometricsAction()
    clearUserDefault()
}

func clearUserDefault() {
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
}

func removeBiometricsAction(){
    let _ = KeychainService.shared.deleteJSONFromKeychain(account: KeyChainKey.shared.accountInfo)
}

func defaultDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    dateFormatter.locale = Locale(identifier: "en_US")
    dateFormatter.timeZone = TimeZone.current
    return dateFormatter
}

func changeFormat(_ dateStr:String)-> String {
    let changeDate = dateStr
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = dateFormatter.date(from: changeDate) {
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    return dateStr
}

func getUserNewInfo(VC:UIViewController, finishAction:(()->())?){
    guard !CommonKey.shared.authToken.isEmpty else { return }
    NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.profile, authorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
        guard let data = data, statusCode == 200 else {
            showAlert(VC: VC, title: "error".localized, message: errorMSG)
            return
        }
        if let profileNewInfo = try? JSONDecoder().decode(ProfileNewInfo.self, from: data) {
            var userInfo = profileNewInfo
            if let experiencePoint = profileNewInfo.experiencePoint {
                userInfo.levelInfo = getLevelInfo(experiencePoint)
            }
            CurrentUserInfo.shared.currentProfileNewInfo = nil
            CurrentUserInfo.shared.currentProfileNewInfo = userInfo
            if let finishAction = finishAction {
                finishAction()
            }
        }
    }
}

private func getLevelInfo(_ experiencePoint:Int) -> LevelInfo {
//    var newUserInfo = userinfo
//    let experiencePoint = userinfo.experiencePoint
    var levelInfo:LevelInfo = LevelInfo(progress: 1, chickenLevel: .one)
    if experiencePoint >= 0 && experiencePoint <= 10000{
        levelInfo.chickenLevel = .one
    }else if experiencePoint > 10000 && experiencePoint <= 20000{
        levelInfo.chickenLevel = .two
    }else if experiencePoint > 20000 && experiencePoint <= 30000{
        levelInfo.chickenLevel = .three
    }else if experiencePoint > 30000 && experiencePoint <= 40000{
        levelInfo.chickenLevel = .four
    }else if experiencePoint > 40000 && experiencePoint <= 50000{
        levelInfo.chickenLevel = .five
    }else if experiencePoint > 50000 && experiencePoint <= 60000{
        levelInfo.chickenLevel = .six
    }else if experiencePoint > 60000 && experiencePoint <= 70000{
        levelInfo.chickenLevel = .seven
    }else if experiencePoint > 70000 && experiencePoint <= 80000{
        levelInfo.chickenLevel = .eight
    }else if experiencePoint > 80000 && experiencePoint <= 90000{
        levelInfo.chickenLevel = .nine
    }else if experiencePoint > 90000 && experiencePoint <= 100000{
        levelInfo.chickenLevel = .ten
    }
    
    if experiencePoint >= 0 && experiencePoint <= 100{
        levelInfo.progress = 1
    }
    else if experiencePoint > 100 && experiencePoint <= 400 {
        levelInfo.progress = 2
    }
    else if experiencePoint > 400 && experiencePoint <= 900 {
        levelInfo.progress = 3
    }
    else if experiencePoint > 900 && experiencePoint <= 1600 {
        levelInfo.progress = 4
    }
    else if experiencePoint > 1600 && experiencePoint <= 2500 {
        levelInfo.progress = 5
    }
    else if experiencePoint > 2500 && experiencePoint <= 3600 {
        levelInfo.progress = 6
    }
    else if experiencePoint > 3600 && experiencePoint <= 4900 {
        levelInfo.progress = 7
    }
    else if experiencePoint > 4900 && experiencePoint <= 6400 {
        levelInfo.progress = 8
    }
    else if experiencePoint > 6400 && experiencePoint <= 8100 {
        levelInfo.progress = 9
    }
    else if experiencePoint > 8100 && experiencePoint <= 10000 {
        levelInfo.progress = 10
    }
    else if experiencePoint > 10000 && experiencePoint <= 10100{
        levelInfo.progress = 1
    }
    else if experiencePoint > 10100 && experiencePoint <= 10400 {
        levelInfo.progress = 2
    }
    else if experiencePoint > 10400 && experiencePoint <= 10900 {
        levelInfo.progress = 3
    }
    else if experiencePoint > 10900 && experiencePoint <= 11600 {
        levelInfo.progress = 4
    }
    else if experiencePoint > 11600 && experiencePoint <= 12500 {
        levelInfo.progress = 5
    }
    else if experiencePoint > 12500 && experiencePoint <= 13600 {
        levelInfo.progress = 6
    }
    else if experiencePoint > 13600 && experiencePoint <= 14900 {
        levelInfo.progress = 7
    }
    else if experiencePoint > 14900 && experiencePoint <= 16400 {
        levelInfo.progress = 8
    }
    else if experiencePoint > 16400 && experiencePoint <= 18100 {
        levelInfo.progress = 9
    }
    else if experiencePoint > 18100 && experiencePoint <= 20000 {
        levelInfo.progress = 10
    }
    else if experiencePoint > 20000 && experiencePoint <= 20100{
        levelInfo.progress = 1
    }
    else if experiencePoint > 20100 && experiencePoint <= 20400 {
        levelInfo.progress = 2
    }
    else if experiencePoint > 20400 && experiencePoint <= 20900 {
        levelInfo.progress = 3
    }
    else if experiencePoint > 20900 && experiencePoint <= 21600 {
        levelInfo.progress = 4
    }
    else if experiencePoint > 21600 && experiencePoint <= 22500 {
        levelInfo.progress = 5
    }
    else if experiencePoint > 22500 && experiencePoint <= 23600 {
        levelInfo.progress = 6
    }
    else if experiencePoint > 23600 && experiencePoint <= 24900 {
        levelInfo.progress = 7
    }
    else if experiencePoint > 24900 && experiencePoint <= 26400 {
        levelInfo.progress = 8
    }
    else if experiencePoint > 26400 && experiencePoint <= 28100 {
        levelInfo.progress = 9
    }
    else if experiencePoint > 28100 && experiencePoint <= 30000 {
        levelInfo.progress = 10
    }
    else if experiencePoint > 30000 && experiencePoint <= 30100{
        levelInfo.progress = 1
    }
    else if experiencePoint > 30100 && experiencePoint <= 30400 {
        levelInfo.progress = 2
    }
    else if experiencePoint > 30400 && experiencePoint <= 30900 {
        levelInfo.progress = 3
    }
    else if experiencePoint > 30900 && experiencePoint <= 31600 {
        levelInfo.progress = 4
    }
    else if experiencePoint > 31600 && experiencePoint <= 32500 {
        levelInfo.progress = 5
    }
    else if experiencePoint > 32500 && experiencePoint <= 33600 {
        levelInfo.progress = 6
    }
    else if experiencePoint > 33600 && experiencePoint <= 34900 {
        levelInfo.progress = 7
    }
    else if experiencePoint > 34900 && experiencePoint <= 36400 {
        levelInfo.progress = 8
    }
    else if experiencePoint > 36400 && experiencePoint <= 38100 {
        levelInfo.progress = 9
    }
    else if experiencePoint > 38100 && experiencePoint <= 40000 {
        levelInfo.progress = 10
    }
    else if experiencePoint > 40000 && experiencePoint <= 40100{
        levelInfo.progress = 1
    }
    else if experiencePoint > 40100 && experiencePoint <= 40400 {
        levelInfo.progress = 2
    }
    else if experiencePoint > 40400 && experiencePoint <= 40900 {
        levelInfo.progress = 3
    }
    else if experiencePoint > 40900 && experiencePoint <= 41600 {
        levelInfo.progress = 4
    }
    else if experiencePoint > 41600 && experiencePoint <= 42500 {
        levelInfo.progress = 5
    }
    else if experiencePoint > 42500 && experiencePoint <= 43600 {
        levelInfo.progress = 6
    }
    else if experiencePoint > 43600 && experiencePoint <= 44900 {
        levelInfo.progress = 7
    }
    else if experiencePoint > 44900 && experiencePoint <= 46400 {
        levelInfo.progress = 8
    }
    else if experiencePoint > 46400 && experiencePoint <= 48100 {
        levelInfo.progress = 9
    }
    else if experiencePoint > 48100 && experiencePoint <= 50000 {
        levelInfo.progress = 10
    }
    else if experiencePoint > 50000 && experiencePoint <= 50100{
        levelInfo.progress = 1
    }
    else if experiencePoint > 50100 && experiencePoint <= 50400 {
        levelInfo.progress = 2
    }
    else if experiencePoint > 50400 && experiencePoint <= 50900 {
        levelInfo.progress = 3
    }
    else if experiencePoint > 50900 && experiencePoint <= 51600 {
        levelInfo.progress = 4
    }
    else if experiencePoint > 51600 && experiencePoint <= 52500 {
        levelInfo.progress = 5
    }
    else if experiencePoint > 52500 && experiencePoint <= 53600 {
        levelInfo.progress = 6
    }
    else if experiencePoint > 53600 && experiencePoint <= 54900 {
        levelInfo.progress = 7
    }
    else if experiencePoint > 54900 && experiencePoint <= 56400 {
        levelInfo.progress = 8
    }
    else if experiencePoint > 56400 && experiencePoint <= 58100 {
        levelInfo.progress = 9
    }
    else if experiencePoint > 58100 && experiencePoint <= 60000 {
        levelInfo.progress = 10
    }
    else if experiencePoint > 60000 && experiencePoint <= 60100{
        levelInfo.progress = 1
    }
    else if experiencePoint > 60100 && experiencePoint <= 60400 {
        levelInfo.progress = 2
    }
    else if experiencePoint > 60400 && experiencePoint <= 60900 {
        levelInfo.progress = 3
    }
    else if experiencePoint > 60900 && experiencePoint <= 61600 {
        levelInfo.progress = 4
    }
    else if experiencePoint > 61600 && experiencePoint <= 62500 {
        levelInfo.progress = 5
    }
    else if experiencePoint > 62500 && experiencePoint <= 63600 {
        levelInfo.progress = 6
    }
    else if experiencePoint > 63600 && experiencePoint <= 64900 {
        levelInfo.progress = 7
    }
    else if experiencePoint > 64900 && experiencePoint <= 66400 {
        levelInfo.progress = 8
    }
    else if experiencePoint > 66400 && experiencePoint <= 68100 {
        levelInfo.progress = 9
    }
    else if experiencePoint > 68100 && experiencePoint <= 70000 {
        levelInfo.progress = 10
    }
    else if experiencePoint > 70000 && experiencePoint <= 70100{
        levelInfo.progress = 1
    }
    else if experiencePoint > 70100 && experiencePoint <= 70400 {
        levelInfo.progress = 2
    }
    else if experiencePoint > 70400 && experiencePoint <= 70900 {
        levelInfo.progress = 3
    }
    else if experiencePoint > 70900 && experiencePoint <= 71600 {
        levelInfo.progress = 4
    }
    else if experiencePoint > 71600 && experiencePoint <= 72500 {
        levelInfo.progress = 5
    }
    else if experiencePoint > 72500 && experiencePoint <= 73600 {
        levelInfo.progress = 6
    }
    else if experiencePoint > 73600 && experiencePoint <= 74900 {
        levelInfo.progress = 7
    }
    else if experiencePoint > 74900 && experiencePoint <= 76400 {
        levelInfo.progress = 8
    }
    else if experiencePoint > 76400 && experiencePoint <= 78100 {
        levelInfo.progress = 9
    }
    else if experiencePoint > 78100 && experiencePoint <= 80000 {
        levelInfo.progress = 10
    }
    else if experiencePoint > 80000 && experiencePoint <= 80100{
        levelInfo.progress = 1
    }
    else if experiencePoint > 80100 && experiencePoint <= 80400 {
        levelInfo.progress = 2
    }
    else if experiencePoint > 80400 && experiencePoint <= 80900 {
        levelInfo.progress = 3
    }
    else if experiencePoint > 80900 && experiencePoint <= 81600 {
        levelInfo.progress = 4
    }
    else if experiencePoint > 81600 && experiencePoint <= 82500 {
        levelInfo.progress = 5
    }
    else if experiencePoint > 82500 && experiencePoint <= 83600 {
        levelInfo.progress = 6
    }
    else if experiencePoint > 83600 && experiencePoint <= 84900 {
        levelInfo.progress = 7
    }
    else if experiencePoint > 84900 && experiencePoint <= 86400 {
        levelInfo.progress = 8
    }
    else if experiencePoint > 86400 && experiencePoint <= 88100 {
        levelInfo.progress = 9
    }
    else if experiencePoint > 88100 && experiencePoint <= 90000 {
        levelInfo.progress = 10
    }
    else if experiencePoint > 90000 && experiencePoint <= 90100{
        levelInfo.progress = 1
    }
    else if experiencePoint > 90100 && experiencePoint <= 90400 {
        levelInfo.progress = 2
    }
    else if experiencePoint > 90400 && experiencePoint <= 90900 {
        levelInfo.progress = 3
    }
    else if experiencePoint > 90900 && experiencePoint <= 91600 {
        levelInfo.progress = 4
    }
    else if experiencePoint > 91600 && experiencePoint <= 92500 {
        levelInfo.progress = 5
    }
    else if experiencePoint > 92500 && experiencePoint <= 93600 {
        levelInfo.progress = 6
    }
    else if experiencePoint > 93600 && experiencePoint <= 94900 {
        levelInfo.progress = 7
    }
    else if experiencePoint > 94900 && experiencePoint <= 96400 {
        levelInfo.progress = 8
    }
    else if experiencePoint > 96400 && experiencePoint <= 98100 {
        levelInfo.progress = 9
    }
    else if experiencePoint > 98100 && experiencePoint <= 100000 {
        levelInfo.progress = 10
    }
    return levelInfo
}

func generateBarCode(from string: String) -> UIImage? {
    let data = string.data(using: .ascii)
    if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        if let output = filter.outputImage?.transformed(by: transform) {
            return UIImage(ciImage: output)
        }
    }
    return nil
}

func biometricsAction(){
    
}

func dateLastYearSameDay() -> Date? {
    let calendar = Calendar.current
    let today = Date()
    
    // 使用 DateComponents 來減去一年
    var dateComponents = DateComponents()
    dateComponents.year = -1
    
    // 計算去年同一天的日期
    return calendar.date(byAdding: dateComponents, to: today)
}


func pushVC(targetVC:UIViewController, navigation:UINavigationController) {
    DispatchQueue.main.async {
        if !(navigation.topViewController?.isKind(of: targetVC.classForCoder))!{
            navigation.pushViewController(targetVC, animated: true)
        }
    }
}

func showAlert(VC:UIViewController?, title:String?, message:String? = nil, alertAction:UIAlertAction? = nil, cancelAction:UIAlertAction? = nil) {
    guard let VC = VC else { return }
    DispatchQueue.main.async {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let alertAction = alertAction {
            alertVC.addAction(alertAction)
        }else{
            alertVC.addAction(UIAlertAction(title: "confirm".localized, style: .default))
        }
        if let cancelAction = cancelAction {
            alertVC.addAction(cancelAction)
        }
        VC.present(alertVC, animated: false)
    }
}

func goToSignVC(){
    if let VC = UIStoryboard(name: "Sign", bundle: nil).instantiateViewController(withIdentifier: "Sign") as? SignVC, let topVC = getTopController() {
        VC.modalPresentationStyle = .fullScreen
        topVC.present(VC, animated: true)
    }
}

func removeWhitespace(from string: String) -> String {
    let components = string.components(separatedBy: .whitespaces)
    let filteredString = components.joined()
    return filteredString
}

func validateEmail(text:String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: text)
}

func validatePassword(text:String) -> Bool {
    let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,12}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: text)
}


func validateCellPhone(text:String) -> Bool{
    let mobileReg = "^09\\d{8}$"
    let resgextestMobile = NSPredicate(format: "SELF MATCHES %@", mobileReg).evaluate(with: text)
    return resgextestMobile
}


func cellsForTableView(tableView:UITableView) -> [UITableViewCell] {
    var cells:[UITableViewCell] = []
    let sections = tableView.numberOfSections
    for section in 0...sections - 1 {
        let rows = tableView.numberOfRows(inSection: section)
        for row in 0...rows - 1 {
            let indexPath = IndexPath(row: row, section: section)
            if let cell = tableView.cellForRow(at: indexPath) {
                cells.append(cell)
            }
        }
    }
    return cells
}

func getTopController() -> UIViewController? {
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    if var topController = keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
    return nil
}

func addViewFullScreen(v:UIView) {
    if let topVC = getTopController() {
        topVC.view.addSubview(v)
    }
}

func getDayOfTheWeek() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE"
    return dateFormatter.string(from: Date())
}

func isDateWithinInterval(date: Date, start: Date, end: Date) -> Bool {
    return date >= start && date <= end
}

func getDates(i: Int, currentDate:Date, dateformat:(String,String) = ("yyyy/MM/dd","EEE")) -> (String, String, Date){
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

func dateFromString(_ dateString: String) -> Date? {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return dateFormatter.date(from: dateString)
}

func dateFromStringISO8601(date:Date) -> String {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 8 * 60 * 60)
    let dateString = dateFormatter.string(from: date)
    return dateString
}

func imageWithImage(image:UIImage?, scaledToSize newSize:CGSize) -> UIImage? {
    guard let image = image else { return nil }
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    image.draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
}

func convertDateFormat(inputDateString: String, inputFormat: String, outputFormat: String) -> String? {
    let dateFormatterInput = DateFormatter()
    dateFormatterInput.dateFormat = inputFormat

    if let date = dateFormatterInput.date(from: inputDateString) {
        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.dateFormat = outputFormat
        return dateFormatterOutput.string(from: date)
    } else {
        return nil
    }
}

func getStartAndEndDateOfMonth(_ dateFormat: String = "yyyy-MM-dd") -> (start: String, end: String)? {
    let calendar = Calendar.current
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    let components = calendar.dateComponents([.year, .month], from: now)
    
    // Get the start date of the month
    guard let startOfMonth = calendar.date(from: components) else {
        return nil
    }
    let startString = dateFormatter.string(from: startOfMonth)
    
    // Get the end date of the month
    guard let plusOneMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) else {
        return nil
    }
    let endOfMonth = calendar.date(byAdding: .day, value: -1, to: plusOneMonth)!
    let endString = dateFormatter.string(from: endOfMonth)
    
    return (startString, endString)
}


func getSevenDaysArray(targetDate:Date) -> [(String, String, Date)] {
    let weekDay = getDayOfTheWeek()
    var selectedDatesIndex = 0
    switch weekDay {
    case "Sun":
        selectedDatesIndex = 6
    case "Mon":
        selectedDatesIndex = 0
    case "Tue":
        selectedDatesIndex = 1
    case "Wed":
        selectedDatesIndex = 2
    case "Thu":
        selectedDatesIndex = 3
    case "Fri":
        selectedDatesIndex = 4
    case "Sat":
        selectedDatesIndex = 5
    default:
        break
    }
    var sevenDaysToShow:[(String, String, Date)] = []
    for index in 0..<7 {
        let newIndex = index - selectedDatesIndex
        sevenDaysToShow.append(getDates(i: newIndex, currentDate: targetDate))
    }
    return sevenDaysToShow
}

func fadeInOutAni(showView:UIView, finishAction:(()->())?){
    showView.alpha = 0
    keyWindow?.addSubview(showView)
    UIView.animate(withDuration: 1, delay: 0) {
        showView.alpha = 1
    } completion: { _ in
        UIView.animate(withDuration: 1, delay: 1) {
            showView.alpha = 0
        } completion: { _ in
            showView.removeFromSuperview()
            if let finishAction = finishAction {
                finishAction()
            }
        }
    }
}

func messagingSubscribe() {
    Messaging.messaging().subscribe(toTopic: CurrentUserInfo.shared.currentAccountInfo.userPhoneNumber) { error in
        guard error == nil else {
            print(error?.localizedDescription ?? "")
            return
        }
        UserDefaults.standard.setValue(true, forKey: UserDefaultKey.shared.isSubscribed)
    }
}

func messagingUnSubscribe() {
    Messaging.messaging().unsubscribe(fromTopic: CurrentUserInfo.shared.currentAccountInfo.userPhoneNumber){ error in
        guard error == nil else {
            print(error?.localizedDescription ?? "")
            return
        }
        UserDefaults.standard.setValue(false, forKey: UserDefaultKey.shared.isSubscribed)
    }
}

struct Certificates {
    
    static let certificate: SecCertificate = Certificates.certificate(filename: "cert")
    
    private static func certificate(filename: String) -> SecCertificate {
        let filePath = Bundle.main.path(forResource: filename, ofType: "cer")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        let certificate = SecCertificateCreateWithData(nil, data as CFData)!
        return certificate
    }
}

struct UseRecordInfo:Codable {
    var userPhoneNumber:String?
    var storeName:String?
    var storeID:String?
    var time:String?
    var type:RecycleType?
    var recycleDetails:RecycleDetails?
    
    enum CodingKeys:String, CodingKey {
        case userPhoneNumber = "userPhoneNumber"
        case storeName = "storeName"
        case storeID = "storeID"
        case time = "time"
        case type = "type"
        case recycleDetails = "recycleDetails"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userPhoneNumber = try? container.decodeIfPresent(String.self, forKey: .userPhoneNumber)
        storeName = try? container.decodeIfPresent(String.self, forKey: .storeName)
        storeID = try? container.decodeIfPresent(String.self, forKey: .storeID)
        time = try? container.decodeIfPresent(String.self, forKey: .time)
        type = try? container.decodeIfPresent(RecycleType.self, forKey: .type)
        recycleDetails = try? container.decodeIfPresent(RecycleDetails.self, forKey: .recycleDetails)
    }
}

enum RecycleType: String, Codable, CaseIterable {
    case battery = "battery"
    case bottle = "bottle"
    case coloredBottle = "coloredBottle"
    case colorlessBottle = "colorlessBottle"
    case can = "can"
    case cup = "cup"
}

struct RecycleDetails:Codable {
    var battery:Int?
    var bottle:Int?
    var coloredBottle:Int?
    var colorlessBottle:Int?
    var can:Int?
    var cup:Int?
}

struct ApiResult:Codable {
    var message:String?
    var status:ApiStatus?
    
    enum CodingKeys:String, CodingKey {
        case status = "status"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try? container.decodeIfPresent(String.self, forKey: .message)
        status = try? container.decodeIfPresent(ApiStatus.self, forKey: .status)
    }
}

enum ApiStatus:String, Codable {
    case success = "success"
    case failure = "failure"
}
