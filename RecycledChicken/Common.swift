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

let keyWindow = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first { $0.isKeyWindow }


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

struct RedirectURL {
    static let pointDetail = "https://www.buenopartners.com.tw//faq?questionId=92276fa2-b954-46ea-a5e5-e82d63d3e533"
    static let buenopartners = "https://www.buenopartners.com.tw/formula"
}

struct APIUrl {
    static let domainName = "https://useries.buenooptics.com:8443/app/v2"
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
    static let couponsUnlock = "/coupons/unlock"
    static let lotteryUnlock = "/lottery/unlock"
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

func getRecords(_ sites: [String]? = nil, _ startTime: String, _ endTime: String, completion: @escaping (_ statusCode: Int?, _ errorMSG: String?, _ useRecordInfos: [UseRecordInfo]?, _ battery: Int?, _ bottle: Int?, _ colorledBottle: Int?, _ colorlessBottle: Int?, _ can: Int?, _ cup: Int?) -> Void) {
    guard !CommonKey.shared.authToken.isEmpty else { return }
    var urlStr = APIUrl.domainName + APIUrl.records + "?startTime=\(startTime)T00:00:00.000+08:00&endTime=\(endTime)T23:59:59.999+08:00"
    if let sites = sites {
        let sitesStr = sites.joined(separator: ",")
        urlStr = APIUrl.domainName + APIUrl.records + "?startTime=\(startTime)T00:00:00.000+08:00&endTime=\(endTime)T23:59:59.999+08:00&sites=\(sitesStr)"
    }
    print(urlStr)
    NetworkManager.shared.get(url: urlStr,
                               authorizationToken: CommonKey.shared.authToken,
                               responseType: [UseRecordInfo].self) { result in
        switch result {
        case .success(let useRecordInfos):
            var batteryInt: Int?
            var bottleInt: Int?
            var colorledBottleInt: Int?
            var colorlessBottleInt: Int?
            var canInt: Int?
            var cupInt: Int?
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
            completion(200, nil, useRecordInfos, batteryInt, bottleInt, colorledBottleInt, colorlessBottleInt, canInt, cupInt)
        case .failure(let error):
            let statusCode = (error as? NetworkError).flatMap { 
                if case .httpError(let code, _) = $0 { return code }
                return nil
            }
            completion(statusCode, error.localizedDescription, nil, nil, nil, nil, nil, nil, nil)
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

func getUserNewInfo(VC: UIViewController, finishAction: (() -> ())?) {
    guard !CommonKey.shared.authToken.isEmpty else { return }
    NetworkManager.shared.get(url: APIUrl.domainName + APIUrl.profile,
                               authorizationToken: CommonKey.shared.authToken,
                               responseType: ProfileNewInfo.self) { result in
        switch result {
        case .success(let profileNewInfo):
            var userInfo = profileNewInfo
            if let experiencePoint = profileNewInfo.experiencePoint {
                userInfo.levelInfo = LevelCalculation().getLevelInfo(experiencePoint)
            }
            CurrentUserInfo.shared.currentProfileNewInfo = nil
            CurrentUserInfo.shared.currentProfileNewInfo = userInfo
            if let finishAction = finishAction {
                finishAction()
            }
        case .failure(let error):
            DispatchQueue.main.async {
                showAlert(VC: VC, title: "error".localized, message: error.localizedDescription)
            }
        }
    }
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
    if let windowScene = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first(where: { $0.activationState == .foregroundActive }), let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }), var topController = keyWindow.rootViewController {
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
