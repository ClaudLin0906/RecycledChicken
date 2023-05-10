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
        switchTableViewInfo(title: "APP活動通知", isTrue: false),
        switchTableViewInfo(title: "信件通知", isTrue: true),
        switchTableViewInfo(title: "回收機消息通知", isTrue: true)
    ]
    
    var accountTableViewInfos:[accountTableViewInfo] =
    [
        accountTableViewInfo(title: "連動與綁定帳號"),
        accountTableViewInfo(title: "刪除帳號")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "系統設定"
        setDefaultNavigationBackBtn2()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        switchTableView.setSeparatorLocation()
        accountTableView.setSeparatorLocation()
    }

}

extension SystemSettingVC:UITableViewDelegate, UITableViewDataSource {
    
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
