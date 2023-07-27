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
    let googleMapKey = "AIzaSyAcVNJwxg_jJNKCeX4dDDkqmCL8RmVAbSo"//廠商
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
}

struct WebViewUrl{
    static let PrivacyPolicyURL = "https://www.buenopartners.com.tw/privacy"
    static let CommonPronblemURL = "https://www.buenopartners.com.tw/faq"
}

let attributes: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.font: UIFont(name: "GenJyuuGothic-Normal", size: 17)!,
//    NSAttributedString.Key.foregroundColor: UIColor.white,
    NSAttributedString.Key.kern: 5 // 設定字距
]

let attributes2: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.font: UIFont(name: "GenJyuuGothic-Normal", size: 17)!,
//    NSAttributedString.Key.foregroundColor: UIColor.black,
    NSAttributedString.Key.kern: 5 // 設定字距
]

public class CommonUserDefaultsKey{
    static let removeBackground = "removeBackground"
}

protocol NibOwnerLoadable: AnyObject {
    static var nib: UINib { get }
}

func loginOutRemoveObject(){
    CurrentUserInfo.shared.currentProfileInfo = nil
    CommonKey.shared.authToken = ""
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
            userInfo = computeGrade(userinfo: userInfo)
            
            CurrentUserInfo.shared.currentProfileInfo = userInfo
            if let finishAction = finishAction {
                finishAction()
            }
        }
    }
}

private func computeGrade(userinfo:ProfileInfo) -> ProfileInfo{
    var newUserInfo = userinfo
    let experiencePoint = userinfo.experiencePoint
    if experiencePoint >= 0 && experiencePoint <= 100{
        newUserInfo.levelInfo?.level = 1
        newUserInfo.levelInfo?.chickenLevel = 1
        newUserInfo.levelInfo?.chickenLevelName = "碳員"
    }
    else if experiencePoint > 100 && experiencePoint <= 400 {
        newUserInfo.levelInfo?.level = 2
        newUserInfo.levelInfo?.chickenLevel = 1
        newUserInfo.levelInfo?.chickenLevelName = "碳員"
    }
    else if experiencePoint > 400 && experiencePoint <= 900 {
        newUserInfo.levelInfo?.level = 3
        newUserInfo.levelInfo?.chickenLevel = 1
        newUserInfo.levelInfo?.chickenLevelName = "碳員"
    }
    else if experiencePoint > 900 && experiencePoint <= 1600 {
        newUserInfo.levelInfo?.level = 4
        newUserInfo.levelInfo?.chickenLevel = 1
        newUserInfo.levelInfo?.chickenLevelName = "碳員"
    }
    else if experiencePoint > 1600 && experiencePoint <= 2500 {
        newUserInfo.levelInfo?.level = 5
        newUserInfo.levelInfo?.chickenLevel = 1
        newUserInfo.levelInfo?.chickenLevelName = "碳員"
    }
    else if experiencePoint > 2500 && experiencePoint <= 3600 {
        newUserInfo.levelInfo?.level = 6
        newUserInfo.levelInfo?.chickenLevel = 1
        newUserInfo.levelInfo?.chickenLevelName = "碳員"
    }
    else if experiencePoint > 3600 && experiencePoint <= 4900 {
        newUserInfo.levelInfo?.level = 7
        newUserInfo.levelInfo?.chickenLevel = 1
        newUserInfo.levelInfo?.chickenLevelName = "碳員"
    }
    else if experiencePoint > 4900 && experiencePoint <= 6400 {
        newUserInfo.levelInfo?.level = 8
        newUserInfo.levelInfo?.chickenLevel = 1
        newUserInfo.levelInfo?.chickenLevelName = "碳員"
    }
    else if experiencePoint > 6400 && experiencePoint <= 8100 {
        newUserInfo.levelInfo?.level = 9
        newUserInfo.levelInfo?.chickenLevel = 1
        newUserInfo.levelInfo?.chickenLevelName = "碳員"
    }
    else if experiencePoint > 8100 && experiencePoint <= 10000 {
        newUserInfo.levelInfo?.level = 10
        newUserInfo.levelInfo?.chickenLevel = 1
        newUserInfo.levelInfo?.chickenLevelName = "碳員"
    }
    else if experiencePoint >= 10000 && experiencePoint <= 10100{
        newUserInfo.levelInfo?.level = 1
        newUserInfo.levelInfo?.chickenLevel = 2
        newUserInfo.levelInfo?.chickenLevelName = "割草雞"
    }
    else if experiencePoint > 10100 && experiencePoint <= 10400 {
        newUserInfo.levelInfo?.level = 2
        newUserInfo.levelInfo?.chickenLevel = 2
        newUserInfo.levelInfo?.chickenLevelName = "割草雞"
    }
    else if experiencePoint > 10400 && experiencePoint <= 10900 {
        newUserInfo.levelInfo?.level = 3
        newUserInfo.levelInfo?.chickenLevel = 2
        newUserInfo.levelInfo?.chickenLevelName = "割草雞"
    }
    else if experiencePoint > 10900 && experiencePoint <= 11600 {
        newUserInfo.levelInfo?.level = 4
        newUserInfo.levelInfo?.chickenLevel = 2
        newUserInfo.levelInfo?.chickenLevelName = "割草雞"
    }
    else if experiencePoint > 11600 && experiencePoint <= 12500 {
        newUserInfo.levelInfo?.level = 5
        newUserInfo.levelInfo?.chickenLevel = 2
        newUserInfo.levelInfo?.chickenLevelName = "割草雞"
    }
    else if experiencePoint > 12500 && experiencePoint <= 13600 {
        newUserInfo.levelInfo?.level = 6
        newUserInfo.levelInfo?.chickenLevel = 2
        newUserInfo.levelInfo?.chickenLevelName = "割草雞"
    }
    else if experiencePoint > 13600 && experiencePoint <= 14900 {
        newUserInfo.levelInfo?.level = 7
        newUserInfo.levelInfo?.chickenLevel = 2
        newUserInfo.levelInfo?.chickenLevelName = "割草雞"
    }
    else if experiencePoint > 14900 && experiencePoint <= 16400 {
        newUserInfo.levelInfo?.level = 8
        newUserInfo.levelInfo?.chickenLevel = 2
        newUserInfo.levelInfo?.chickenLevelName = "割草雞"
    }
    else if experiencePoint > 16400 && experiencePoint <= 18100 {
        newUserInfo.levelInfo?.level = 9
        newUserInfo.levelInfo?.chickenLevel = 2
        newUserInfo.levelInfo?.chickenLevelName = "割草雞"
    }
    else if experiencePoint > 18100 && experiencePoint <= 20000 {
        newUserInfo.levelInfo?.level = 10
        newUserInfo.levelInfo?.chickenLevel = 2
        newUserInfo.levelInfo?.chickenLevelName = "割草雞"
    }
    return newUserInfo
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

func showAlert(VC:UIViewController, title:String? ,message:String?, alertAction:UIAlertAction?) {
    DispatchQueue.main.async {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let alertAction = alertAction {
            alertVC.addAction(alertAction)
        }else{
            alertVC.addAction(UIAlertAction(title: "確定", style: .default))
        }
        VC.present(alertVC, animated: false)
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
