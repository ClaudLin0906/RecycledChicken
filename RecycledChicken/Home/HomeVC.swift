//
//  HomeVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import UIKit
import FirebaseMessaging
class HomeVC: CustomRootVC {
    
    @IBOutlet weak var barcodeView:BarCodeView!
    
    @IBOutlet weak var carbonReductionLogBtn:UIButton!
    
    @IBOutlet weak var currentDateLabel:UILabel!
    
    @IBOutlet weak var welcomeLabel:UILabel!
    
    @IBOutlet weak var batteryLabel:UILabel!
    
    @IBOutlet weak var bottleLabel:UILabel!
    
    @IBOutlet weak var chickenLevelImageView:UIImageView!
    
    @IBOutlet weak var trendChartImageView:UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
//        NotificationCenter.default.addObserver(self, selector: #selector(receiveCalenderCell(_:)), name: .calenderCellOnCilck, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo(VC: self, finishAction: {
            DispatchQueue.main.async {
                if let levelObject = getLevelObject(), let image = levelObject.chicken {
                    self.chickenLevelImageView.image = image
                }
                if let image = self.getTrendChart() {
                    self.trendChartImageView.image = image
                }
                
                self.barcodeView.code = CurrentUserInfo.shared.currentProfileInfo?.userPhoneNumber ?? "0912345678"
                self.barcodeView.setTitle()
            }

            Messaging.messaging().subscribe(toTopic: CurrentUserInfo.shared.currentAccountInfo.userPhoneNumber) { error in
            }
            
        })
    }
    
    private func getTrendChart() -> UIImage?{
        if let levelInfo = CurrentUserInfo.shared.currentProfileInfo?.levelInfo {
            var image:UIImage?
            switch levelInfo.level {
            case 1:
                image = UIImage(named: "RecycledLevel1")
            case 2:
                image = UIImage(named: "RecycledLevel2")
            case 3:
                image = UIImage(named: "RecycledLevel3")
            case 4:
                image = UIImage(named: "RecycledLevel4")
            case 5:
                image = UIImage(named: "RecycledLevel5")
            case 6:
                image = UIImage(named: "RecycledLevel6")
            case 7:
                image = UIImage(named: "RecycledLevel7")
            case 8:
                image = UIImage(named: "RecycledLevel8")
            case 9:
                image = UIImage(named: "RecycledLevel9")
            case 10:
                image = UIImage(named: "RecycledLevel10")
            default:
                image = nil
            }
            return image
        }
        return nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FirstTime && LoginSuccess {
//            let adView = ADView(frame: UIScreen.main.bounds)
            let adView = ADView(frame: UIScreen.main.bounds, type: .isHome)
            keyWindow?.addSubview(adView)
            FirstTime = false
            NotificationCenter.default.post(name: .removeBackground, object: nil)
        }
        
        currentDateLabel.text = getDates(i: 0, currentDate: Date()).0
        updateCurrentDateInfo()
    }
    
    private func UIInit(){
        carbonReductionLogBtn.layer.borderWidth = 1
        carbonReductionLogBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
    }
    
    private func getChoseDateRecycleAmount(){
        guard CommonKey.shared.authToken != "", CurrentUserInfo.shared.isGuest == false else { return }
        computeDate(CustomCalenderModel.shared.selectedDate, endTime: CustomCalenderModel.shared.selectedDate, completion: { batteryStr, bottleStr in
            DispatchQueue.main.async {
                self.batteryLabel.text = batteryStr
                self.bottleLabel.text = bottleStr
            }
        })
    }
    
    private func computeDate(_ startTime:String, endTime:String, completion: @escaping (String, String) -> Void){
        let urlStr = APIUrl.domainName + APIUrl.useRecord + "?startTime=\(startTime)T00:00:00.000+08:00&endTime=\(endTime)T23:59:59.999+08:00"
        NetworkManager.shared.getJSONBody(urlString: urlStr, authorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            var batteryInt = 0
            var bottleInt = 0
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                let useRecordInfos = try! JSONDecoder().decode([UseRecordInfo].self, from: JSONSerialization.data(withJSONObject: dic))
                for useRecordInfo in useRecordInfos {
                    if let battery = useRecordInfo.battery {
                        batteryInt += battery
                    }
                    if let bottle = useRecordInfo.bottle {
                        bottleInt += bottle
                    }
                }
            }
            completion(String(batteryInt), String(bottleInt))
        }
    }
    
    func updateCurrentDateInfo(){
        if let username = CurrentUserInfo.shared.currentProfileInfo?.userName , username != "" {
            welcomeLabel.text = "Good morning, \(username)"
        }
        getChoseDateRecycleAmount()
    }
    
    private func signAlert(_ title:String){
        let alertAction = UIAlertAction(title: "註冊", style: .default) { _ in
            loginOutRemoveObject()
            goToSignVC()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        showAlert(VC: self, title: title, message: nil, alertAction: alertAction, cancelAction: cancelAction)
    }
    
    @IBAction func goToCarbonReductionLog(_ sender:UIButton) {
        guard CurrentUserInfo.shared.isGuest == false else {
            signAlert("加入修復計畫，解鎖更多碳竹雞角色！")
            return
        }
        
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "CarbonReductionLog", bundle: Bundle.main).instantiateViewController(identifier: "CarbonReductionLog") as? CarbonReductionLogVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
        
    }
    
    @IBAction func goToProfile(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "Profile", bundle: Bundle.main).instantiateViewController(identifier: "Profile") as? ProfileVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToPersonMessage(_ sender:UIButton) {
        guard CurrentUserInfo.shared.isGuest == false else {
            signAlert("請先註冊為會員，加入泥滑島修復計畫！")
            return
        }
        
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "PersonMessage", bundle: Bundle.main).instantiateViewController(identifier: "PersonMessage") as? PersonMessageVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
        
    }
    
    @IBAction func goToSettingMenu(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "SettingMenu", bundle: Bundle.main).instantiateViewController(identifier: "SettingMenu") as? SettingMenuVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
}
