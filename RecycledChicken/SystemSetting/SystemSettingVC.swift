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
    
    @IBOutlet weak var versionLabel:UILabel!
    
    var switchTableViewInfos:[switchTableViewInfo] =
    [
        switchTableViewInfo(title: "specialMissionNotifications".localized, isTrue: false),
        switchTableViewInfo(title: "emailNotifications".localized, isTrue: true),
        switchTableViewInfo(title: "recyclingMachineNotifications".localized, isTrue: true),
        switchTableViewInfo(title: "biometricIdentification".localized, isTrue: UserDefaults().bool(forKey: UserDefaultKey.shared.biometrics))
    ]
    
    var accountTableViewInfos:[accountTableViewInfo] =
    [
//        accountTableViewInfo(title: "連動與綁定帳號"),
        accountTableViewInfo(title: "enterInvitationCode".localized, inviteInfo: InviteInfo(inviteCode: "", isInvite: false)),
        accountTableViewInfo(title: "deleteAccount".localized)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "systemSetting".localized
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        switchTableView.setSeparatorLocation()
        accountTableView.setSeparatorLocation()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        versionLabel.text = "\("version".localized)\(version)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }

}

extension SystemSettingVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if tableView == accountTableView {
            switch row {
                case 0:
                if let inviteInfo = accountTableViewInfos[row].inviteInfo, !inviteInfo.isInvite {
                    let invitationCodeView = InvitationCodeView(frame: view.window!.frame)
                    invitationCodeView.delegate = self
                    keyWindow?.addSubview(invitationCodeView)
                }
                case 1:
                    if let navigationController = self.navigationController, let VC = UIStoryboard(name: "DeleteAccount", bundle: Bundle.main).instantiateViewController(identifier: "DeleteAccount") as? DeleteAccountVC {
                        pushVC(targetVC: VC, navigation: navigationController)
                    }
                default:
                    break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == switchTableView {
            return switchTableViewInfos.count
        }
        
        if tableView == accountTableView {
            return accountTableViewInfos.count
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if tableView == switchTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as! SwitchTableViewCell
            let info = switchTableViewInfos[row]
            cell.delegate = self
            cell.tag = row
            cell.setCell(info)
            return cell
        }
        if tableView == accountTableView {
            if row == 0, let inviteInfo = accountTableViewInfos[row].inviteInfo, inviteInfo.isInvite {
                let cell = tableView.dequeueReusableCell(withIdentifier: InvitedTableViewCell.identifier, for: indexPath) as! InvitedTableViewCell
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.identifier, for: indexPath) as! AccountTableViewCell
            let info = accountTableViewInfos[row]
            cell.setCell(info)
            return cell
        }
        return UITableViewCell()
    }
}

extension SystemSettingVC:SwitchTableViewCellDelegate{
    
    func changeStatus(_ sender: UISwitch, tag: Int) {
        print(tag)
        switch tag {
        case 3:
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

extension SystemSettingVC:InvitationCodeViewDelegate {
    func comfirmInvitationCode(_ invitationCode: String, finishAction: (() -> ())?) {
        var alertMsg = ""
        if invitationCode == "" {
            alertMsg += "邀請碼不能為空"
        }
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
            return
        }
        let inviteRequestInfo = InviteRequestInfo(inviteCode: invitationCode)
        let inviteRequestInfoDic = try? inviteRequestInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName + APIUrl.enterInviteCode, parameters: inviteRequestInfoDic, AuthorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                return
            }
            let ApiResult = try? JSONDecoder().decode(ApiResult.self, from: data)
            if let status = ApiResult?.status {
                switch status {
                case .success:
                    finishAction?()
                case .failure:
                    break
                }
            }
        }
    }
    
}
