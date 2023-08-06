//
//  SystemSettingVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class SystemSettingVC: CustomVC {

    @IBOutlet weak var switchTableView:UITableView!
    
    @IBOutlet weak var accountTableView:UITableView!
    
    var switchTableViewInfos:[switchTableViewInfo] =
    [
//        switchTableViewInfo(title: "APP活動通知", isTrue: false),
//        switchTableViewInfo(title: "信件通知", isTrue: true),
//        switchTableViewInfo(title: "回收機消息通知", isTrue: true),
        switchTableViewInfo(title: "生物辨識", isTrue: UserDefaults().bool(forKey: UserDefaultKey.shared.biometrics))
    ]
    
    var accountTableViewInfos:[accountTableViewInfo] =
    [
//        accountTableViewInfo(title: "連動與綁定帳號"),
        accountTableViewInfo(title: "刪除帳號")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "系統設定"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        switchTableView.setSeparatorLocation()
        accountTableView.setSeparatorLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }

}

extension SystemSettingVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = tableView.tag
        let row = indexPath.row
        switch (tag, row){
        case(0,0):
            break
        case(0,1):
            break
        case(0,2):
            break
        case(0,3):
            break
        case(1,0):
//            if let navigationController = self.navigationController, let VC = UIStoryboard(name: "BindAccount", bundle: Bundle.main).instantiateViewController(identifier: "BindAccount") as? BindAccountVC {
//                pushVC(targetVC: VC, navigation: navigationController)
//            }
            if let navigationController = self.navigationController, let VC = UIStoryboard(name: "DeleteAccount", bundle: Bundle.main).instantiateViewController(identifier: "DeleteAccount") as? DeleteAccountVC {
                pushVC(targetVC: VC, navigation: navigationController)
            }
        case(1,1):
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tag = tableView.tag
        switch tag {
        case 0:
            return switchTableViewInfos.count
        case 1:
            return accountTableViewInfos.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = tableView.tag
        let row = indexPath.row
        switch tag {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as! SwitchTableViewCell
            let info = switchTableViewInfos[row]
            cell.delegate = self
            cell.tag = row
            cell.setCell(info)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.identifier, for: indexPath) as! AccountTableViewCell
            let info = accountTableViewInfos[row]
            cell.setCell(info)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension SystemSettingVC:SwitchTableViewCellDelegate{
    
    func changeStatus(_ sender: UISwitch, tag: Int) {
        print(tag)
        switch tag {
        case 0:
            if sender.isOn {
                evaluatePolicyAction { scanResult, scanMessage in
                    UserDefaults().set(true, forKey: UserDefaultKey.shared.biometrics)
                    if let accountInfo = try? CurrentUserInfo.shared.currentAccountInfo.jsonString {
                        let _ = KeychainService.shared.saveJsonToKeychain(jsonString: accountInfo, account: KeyChainKey.shared.accountInfo)
                    }
                }
            }else{
                removeBiometricsAction()
            }
        default:
            break
        }
    }
    
        
}
