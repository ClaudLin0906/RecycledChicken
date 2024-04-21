//
//  SettingMenuVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class SettingMenuVC: CustomVC {
    
    @IBOutlet weak var tableView:UITableView!
    
    private var settingMenuInfoArr:[settingMenuInfo] = []
    
    private let defaultSettingMenuInfoArr:[settingMenuInfo] =
    [
        settingMenuInfo(icon: UIImage(named: "组 431")!, title: "systemSetting".localized),
        settingMenuInfo(icon: UIImage(named: "globe")!, title: "languageSetting".localized),
        settingMenuInfo(icon: UIImage(named: "组 430")!, title: "FAQs".localized),
        settingMenuInfo(icon: UIImage(named: "组 428")!, title: "contactPartnership".localized),
        settingMenuInfo(icon: UIImage(named: "组 618")!, title: "termsPrivacyPolicy".localized),
        settingMenuInfo(icon: UIImage(named: "组 423")!, title: "logout".localized)
    ]
    
    private let guestSettingMenuInfoArr:[settingMenuInfo] =
    [
        settingMenuInfo(icon: UIImage(named: "组 423")!, title: "logout".localized)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "memberInformationSystemSettings".localized
        if CurrentUserInfo.shared.isGuest {
            settingMenuInfoArr.append(contentsOf: guestSettingMenuInfoArr)
        }else{
            settingMenuInfoArr.append(contentsOf: defaultSettingMenuInfoArr)
        }
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        tableView.setSeparatorLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }
    
    private func logOutAction(){
        let logOutView = LogOutView(frame: UIScreen.main.bounds)
        logOutView.superVC = self
        addViewFullScreen(v: logOutView)
    }
    
}

extension SettingMenuVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        switch row {
        case 0:
            if CurrentUserInfo.shared.isGuest {
                logOutAction()
            }else{
                if let navigationController = self.navigationController, let VC = UIStoryboard(name: "SystemSetting", bundle: Bundle.main).instantiateViewController(identifier: "SystemSetting") as? SystemSettingVC {
                    pushVC(targetVC: VC, navigation: navigationController)
                }
            }
        case 1:
            if let navigationController = self.navigationController, let VC = UIStoryboard(name: "LanguageSetting", bundle: Bundle.main).instantiateViewController(identifier: "LanguageSetting") as? LanguageSettingVC {
                pushVC(targetVC: VC, navigation: navigationController)
            }
        case 2:
            if let navigationController = self.navigationController, let VC = UIStoryboard(name: "CommonPronblem", bundle: Bundle.main).instantiateViewController(identifier: "CommonPronblem") as? CommonPronblemVC {
                pushVC(targetVC: VC, navigation: navigationController)
            }
        case 3:
            if let navigationController = self.navigationController, let VC = UIStoryboard(name: "ConnectCompany", bundle: Bundle.main).instantiateViewController(identifier: "ConnectCompany") as? ConnectCompanyVC {
                pushVC(targetVC: VC, navigation: navigationController)
            }
        case 4:
            if let navigationController = self.navigationController, let VC = UIStoryboard(name: "PrivacyPolicy", bundle: Bundle.main).instantiateViewController(identifier: "PrivacyPolicy") as? PrivacyPolicyVC {
                pushVC(targetVC: VC, navigation: navigationController)
            }
        case 4:
            logOutAction()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingMenuInfoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingMenuTableViewCell.identifier, for: indexPath) as! SettingMenuTableViewCell
        let row = indexPath.row
        cell.setCell(info: settingMenuInfoArr[row])
        return cell
    }
    
    
}
