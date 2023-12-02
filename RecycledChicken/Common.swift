//
//  Common.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import Foundation
import UIKit
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
    let keepLogin = "keepLogin"
}

struct LevelObject{
    var icon:UIImage?
    var chicken:UIImage?
    var chickenName:String
}

class CurrentUserInfo{
    
    static let shared = CurrentUserInfo()
    
    var currentAccountInfo:AccountInfo = {
        if let jsonData = KeychainService.shared.loadJsonDataFromKeychain(account: KeyChainKey.shared.accountInfo), let accountInfo = try? JSONDecoder().decode(AccountInfo.self, from: jsonData) {
            return accountInfo
        }else {
            return AccountInfo(userPhoneNumber: "", userPassword: "")
        }
        
    }()
    
    var currentProfileInfo:ProfileInfo?
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

struct WebViewUrl{
    static let PrivacyPolicyURL = "https://www.buenopartners.com.tw/privacy"
    static let CommonPronblemURL = "https://www.buenopartners.com.tw/faq"
}

var attributes: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.font: UIFont(name: "GenJyuuGothic-Normal", size: 17)!,
    NSAttributedString.Key.foregroundColor: UIColor.white,
    NSAttributedString.Key.kern: 5 // 設定字距
]

let attributes2: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.font: UIFont(name: "GenJyuuGothic-Normal", size: 17)!,
//    NSAttributedString.Key.foregroundColor: UIColor.black,
    NSAttributedString.Key.kern: 5 // 設定字距
]

public class CommonUserDefaultsKey {
    static let removeBackground = "removeBackground"
}

protocol NibOwnerLoadable: AnyObject {
    static var nib: UINib { get }
}

func loginOutRemoveObject(){
    CurrentUserInfo.shared.currentProfileInfo = nil
    CommonKey.shared.authToken = ""
    LoginSuccess = false
    FirstTime = true
    removeBiometricsAction()
}

func removeBiometricsAction(){
    UserDefaults().set(false, forKey: UserDefaultKey.shared.biometrics)
    let _ = KeychainService.shared.deleteJSONFromKeychain(account: KeyChainKey.shared.accountInfo)
}

func getUserInfo(VC:UIViewController, finishAction:(()->())?){
    NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.searchUserData, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
        guard statusCode == 200 else {
            showAlert(VC: VC, title: "發生錯誤", message: errorMSG, alertAction: nil)
            return
        }
        if let data = data {
            let json = NetworkManager.shared.dataToDictionary(data: data)
            var userInfo = ProfileInfo(userEmail: "", userName: "", userBirth: "", point: 0, userPhoneNumber: "", experiencePoint: 0)
            if let userPhoneNumber = json["userPhoneNumber"] as? String {
                userInfo.userPhoneNumber = userPhoneNumber
            }
            if let userEmail = json["userEmail"] as? String {
                userInfo.userEmail = userEmail
            }
            if let userName = json["userName"] as? String {
                userInfo.userName = userName
            }
            if let point = json["point"] as? Int {
                userInfo.point = point
            }
            if let userBirth = json["userBirth"] as? String {
                userInfo.userBirth = userBirth
            }
            if let experiencePoint = json["experiencePoint"] as? Int {
                userInfo.experiencePoint = experiencePoint
            }
            
            CurrentUserInfo.shared.currentProfileInfo = computeGrade(userinfo: userInfo)
            
            if let finishAction = finishAction {
                finishAction()
            }

        }
    }
}

private func computeGrade(userinfo:ProfileInfo) -> ProfileInfo{
    var newUserInfo = userinfo
    let experiencePoint = userinfo.experiencePoint
    var levelInfo:LevelInfo = LevelInfo(level: 1, chickenLevel: .one)
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
        levelInfo.level = 1
    }
    else if experiencePoint > 100 && experiencePoint <= 400 {
        levelInfo.level = 2
    }
    else if experiencePoint > 400 && experiencePoint <= 900 {
        levelInfo.level = 3
    }
    else if experiencePoint > 900 && experiencePoint <= 1600 {
        levelInfo.level = 4
    }
    else if experiencePoint > 1600 && experiencePoint <= 2500 {
        levelInfo.level = 5
    }
    else if experiencePoint > 2500 && experiencePoint <= 3600 {
        levelInfo.level = 6
    }
    else if experiencePoint > 3600 && experiencePoint <= 4900 {
        levelInfo.level = 7
    }
    else if experiencePoint > 4900 && experiencePoint <= 6400 {
        levelInfo.level = 8
    }
    else if experiencePoint > 6400 && experiencePoint <= 8100 {
        levelInfo.level = 9
    }
    else if experiencePoint > 8100 && experiencePoint <= 10000 {
        levelInfo.level = 10
    }
    else if experiencePoint > 10000 && experiencePoint <= 10100{
        levelInfo.level = 1
    }
    else if experiencePoint > 10100 && experiencePoint <= 10400 {
        levelInfo.level = 2
    }
    else if experiencePoint > 10400 && experiencePoint <= 10900 {
        levelInfo.level = 3
    }
    else if experiencePoint > 10900 && experiencePoint <= 11600 {
        levelInfo.level = 4
    }
    else if experiencePoint > 11600 && experiencePoint <= 12500 {
        levelInfo.level = 5
    }
    else if experiencePoint > 12500 && experiencePoint <= 13600 {
        levelInfo.level = 6
    }
    else if experiencePoint > 13600 && experiencePoint <= 14900 {
        levelInfo.level = 7
    }
    else if experiencePoint > 14900 && experiencePoint <= 16400 {
        levelInfo.level = 8
    }
    else if experiencePoint > 16400 && experiencePoint <= 18100 {
        levelInfo.level = 9
    }
    else if experiencePoint > 18100 && experiencePoint <= 20000 {
        levelInfo.level = 10
    }
    else if experiencePoint > 20000 && experiencePoint <= 20100{
        levelInfo.level = 1
    }
    else if experiencePoint > 20100 && experiencePoint <= 20400 {
        levelInfo.level = 2
    }
    else if experiencePoint > 20400 && experiencePoint <= 20900 {
        levelInfo.level = 3
    }
    else if experiencePoint > 20900 && experiencePoint <= 21600 {
        levelInfo.level = 4
    }
    else if experiencePoint > 21600 && experiencePoint <= 22500 {
        levelInfo.level = 5
    }
    else if experiencePoint > 22500 && experiencePoint <= 23600 {
        levelInfo.level = 6
    }
    else if experiencePoint > 23600 && experiencePoint <= 24900 {
        levelInfo.level = 7
    }
    else if experiencePoint > 24900 && experiencePoint <= 26400 {
        levelInfo.level = 8
    }
    else if experiencePoint > 26400 && experiencePoint <= 28100 {
        levelInfo.level = 9
    }
    else if experiencePoint > 28100 && experiencePoint <= 30000 {
        levelInfo.level = 10
    }
    else if experiencePoint > 30000 && experiencePoint <= 30100{
        levelInfo.level = 1
    }
    else if experiencePoint > 30100 && experiencePoint <= 30400 {
        levelInfo.level = 2
    }
    else if experiencePoint > 30400 && experiencePoint <= 30900 {
        levelInfo.level = 3
    }
    else if experiencePoint > 30900 && experiencePoint <= 31600 {
        levelInfo.level = 4
    }
    else if experiencePoint > 31600 && experiencePoint <= 32500 {
        levelInfo.level = 5
    }
    else if experiencePoint > 32500 && experiencePoint <= 33600 {
        levelInfo.level = 6
    }
    else if experiencePoint > 33600 && experiencePoint <= 34900 {
        levelInfo.level = 7
    }
    else if experiencePoint > 34900 && experiencePoint <= 36400 {
        levelInfo.level = 8
    }
    else if experiencePoint > 36400 && experiencePoint <= 38100 {
        levelInfo.level = 9
    }
    else if experiencePoint > 38100 && experiencePoint <= 40000 {
        levelInfo.level = 10
    }
    else if experiencePoint > 40000 && experiencePoint <= 40100{
        levelInfo.level = 1
    }
    else if experiencePoint > 40100 && experiencePoint <= 40400 {
        levelInfo.level = 2
    }
    else if experiencePoint > 40400 && experiencePoint <= 40900 {
        levelInfo.level = 3
    }
    else if experiencePoint > 40900 && experiencePoint <= 41600 {
        levelInfo.level = 4
    }
    else if experiencePoint > 41600 && experiencePoint <= 42500 {
        levelInfo.level = 5
    }
    else if experiencePoint > 42500 && experiencePoint <= 43600 {
        levelInfo.level = 6
    }
    else if experiencePoint > 43600 && experiencePoint <= 44900 {
        levelInfo.level = 7
    }
    else if experiencePoint > 44900 && experiencePoint <= 46400 {
        levelInfo.level = 8
    }
    else if experiencePoint > 46400 && experiencePoint <= 48100 {
        levelInfo.level = 9
    }
    else if experiencePoint > 48100 && experiencePoint <= 50000 {
        levelInfo.level = 10
    }
    else if experiencePoint > 50000 && experiencePoint <= 50100{
        levelInfo.level = 1
    }
    else if experiencePoint > 50100 && experiencePoint <= 50400 {
        levelInfo.level = 2
    }
    else if experiencePoint > 50400 && experiencePoint <= 50900 {
        levelInfo.level = 3
    }
    else if experiencePoint > 50900 && experiencePoint <= 51600 {
        levelInfo.level = 4
    }
    else if experiencePoint > 51600 && experiencePoint <= 52500 {
        levelInfo.level = 5
    }
    else if experiencePoint > 52500 && experiencePoint <= 53600 {
        levelInfo.level = 6
    }
    else if experiencePoint > 53600 && experiencePoint <= 54900 {
        levelInfo.level = 7
    }
    else if experiencePoint > 54900 && experiencePoint <= 56400 {
        levelInfo.level = 8
    }
    else if experiencePoint > 56400 && experiencePoint <= 58100 {
        levelInfo.level = 9
    }
    else if experiencePoint > 58100 && experiencePoint <= 60000 {
        levelInfo.level = 10
    }
    else if experiencePoint > 60000 && experiencePoint <= 60100{
        levelInfo.level = 1
    }
    else if experiencePoint > 60100 && experiencePoint <= 60400 {
        levelInfo.level = 2
    }
    else if experiencePoint > 60400 && experiencePoint <= 60900 {
        levelInfo.level = 3
    }
    else if experiencePoint > 60900 && experiencePoint <= 61600 {
        levelInfo.level = 4
    }
    else if experiencePoint > 61600 && experiencePoint <= 62500 {
        levelInfo.level = 5
    }
    else if experiencePoint > 62500 && experiencePoint <= 63600 {
        levelInfo.level = 6
    }
    else if experiencePoint > 63600 && experiencePoint <= 64900 {
        levelInfo.level = 7
    }
    else if experiencePoint > 64900 && experiencePoint <= 66400 {
        levelInfo.level = 8
    }
    else if experiencePoint > 66400 && experiencePoint <= 68100 {
        levelInfo.level = 9
    }
    else if experiencePoint > 68100 && experiencePoint <= 70000 {
        levelInfo.level = 10
    }
    else if experiencePoint > 70000 && experiencePoint <= 70100{
        levelInfo.level = 1
    }
    else if experiencePoint > 70100 && experiencePoint <= 70400 {
        levelInfo.level = 2
    }
    else if experiencePoint > 70400 && experiencePoint <= 70900 {
        levelInfo.level = 3
    }
    else if experiencePoint > 70900 && experiencePoint <= 71600 {
        levelInfo.level = 4
    }
    else if experiencePoint > 71600 && experiencePoint <= 72500 {
        levelInfo.level = 5
    }
    else if experiencePoint > 72500 && experiencePoint <= 73600 {
        levelInfo.level = 6
    }
    else if experiencePoint > 73600 && experiencePoint <= 74900 {
        levelInfo.level = 7
    }
    else if experiencePoint > 74900 && experiencePoint <= 76400 {
        levelInfo.level = 8
    }
    else if experiencePoint > 76400 && experiencePoint <= 78100 {
        levelInfo.level = 9
    }
    else if experiencePoint > 78100 && experiencePoint <= 80000 {
        levelInfo.level = 10
    }
    else if experiencePoint > 80000 && experiencePoint <= 80100{
        levelInfo.level = 1
    }
    else if experiencePoint > 80100 && experiencePoint <= 80400 {
        levelInfo.level = 2
    }
    else if experiencePoint > 80400 && experiencePoint <= 80900 {
        levelInfo.level = 3
    }
    else if experiencePoint > 80900 && experiencePoint <= 81600 {
        levelInfo.level = 4
    }
    else if experiencePoint > 81600 && experiencePoint <= 82500 {
        levelInfo.level = 5
    }
    else if experiencePoint > 82500 && experiencePoint <= 83600 {
        levelInfo.level = 6
    }
    else if experiencePoint > 83600 && experiencePoint <= 84900 {
        levelInfo.level = 7
    }
    else if experiencePoint > 84900 && experiencePoint <= 86400 {
        levelInfo.level = 8
    }
    else if experiencePoint > 86400 && experiencePoint <= 88100 {
        levelInfo.level = 9
    }
    else if experiencePoint > 88100 && experiencePoint <= 90000 {
        levelInfo.level = 10
    }
    else if experiencePoint > 90000 && experiencePoint <= 90100{
        levelInfo.level = 1
    }
    else if experiencePoint > 90100 && experiencePoint <= 90400 {
        levelInfo.level = 2
    }
    else if experiencePoint > 90400 && experiencePoint <= 90900 {
        levelInfo.level = 3
    }
    else if experiencePoint > 90900 && experiencePoint <= 91600 {
        levelInfo.level = 4
    }
    else if experiencePoint > 91600 && experiencePoint <= 92500 {
        levelInfo.level = 5
    }
    else if experiencePoint > 92500 && experiencePoint <= 93600 {
        levelInfo.level = 6
    }
    else if experiencePoint > 93600 && experiencePoint <= 94900 {
        levelInfo.level = 7
    }
    else if experiencePoint > 94900 && experiencePoint <= 96400 {
        levelInfo.level = 8
    }
    else if experiencePoint > 96400 && experiencePoint <= 98100 {
        levelInfo.level = 9
    }
    else if experiencePoint > 98100 && experiencePoint <= 100000 {
        levelInfo.level = 10
    }
    newUserInfo.levelInfo = levelInfo
    return newUserInfo

}

func getLevelObject()-> LevelObject?{
    let chickenLevel = CurrentUserInfo.shared.currentProfileInfo?.levelInfo?.chickenLevel
    switch chickenLevel {
    case.one:
        return LevelObject(icon: UIImage(named: "level1-icon"), chicken: UIImage(named: "level1"), chickenName: "碳員")
    case.two:
        return LevelObject(icon: UIImage(named: "level2-icon"), chicken: UIImage(named: "level2"), chickenName: "割草雞")
    case.three:
        return LevelObject(icon: UIImage(named: "level3-icon"), chicken: UIImage(named: "level3"), chickenName: "潛水雞")
    case.four:
        return LevelObject(icon: UIImage(named: "level4-icon"), chicken: UIImage(named: "level4"), chickenName: "技術雞")
    case.five:
        return LevelObject(icon: UIImage(named: "level5-icon"), chicken: UIImage(named: "level5"), chickenName: "挖土雞")
    case.six:
        return LevelObject(icon: UIImage(named: "level6-icon"), chicken: UIImage(named: "level6"), chickenName: "紳士雞")
    case.seven:
        return LevelObject(icon: UIImage(named: "level7-icon"), chicken: UIImage(named: "level7"), chickenName: "發電雞")
    case.eight:
        return LevelObject(icon: UIImage(named: "level8-icon"), chicken: UIImage(named: "level8"), chickenName: "冒險雞")
    case.nine:
        return LevelObject(icon: UIImage(named: "level9-icon"), chicken: UIImage(named: "level9"), chickenName: "花雕雞")
    case.ten:
        return LevelObject(icon: UIImage(named: "level10-icon"), chicken: UIImage(named: "level10"), chickenName: "碳長")
    case .none:
        return nil
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

func showAlert(VC:UIViewController, title:String?, message:String? = nil, alertAction:UIAlertAction? = nil, cancelAction:UIAlertAction? = nil) {
    DispatchQueue.main.async {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let alertAction = alertAction {
            alertVC.addAction(alertAction)
        }else{
            alertVC.addAction(UIAlertAction(title: "確定", style: .default))
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

func getDayOfTheWeek() -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE"
    return dateFormatter.string(from: Date())
}

func isDateWithinInterval(date: Date, start: Date, end: Date) -> Bool {
    return date >= start && date <= end
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

func getDateFromStr(dateformat:String = "yyyy-MM-dd HH:mm:ss Z", dateStr:String) -> InfoTime? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateformat
    dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
    if let date = dateFormatter.date(from: dateStr) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return InfoTime(year: year, month: month, day: day)
    } else {
        return nil
    }
}

func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    image.draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
}

func fadeInOutAni(showView:UIView, finishAction:(()->())?){
    showView.alpha = 0
    keyWindow?.addSubview(showView)
    UIView.animate(withDuration: 2, delay: 0) {
        showView.alpha = 1
    } completion: { _ in
        UIView.animate(withDuration: 2, delay: 1) {
            showView.alpha = 0
        } completion: { _ in
            showView.removeFromSuperview()
            if let finishAction = finishAction {
                finishAction()
            }
        }
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

struct UseRecordInfo:Decodable {
    var storeName:String
    var time:String
    var battery:Int?
    var bottle:Int?
}
