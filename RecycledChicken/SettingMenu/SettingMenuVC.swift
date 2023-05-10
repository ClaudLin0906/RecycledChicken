//
//  SettingMenuVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class SettingMenuVC: CustomVC {
    
    @IBOutlet weak var tableView:UITableView!
    
    let settingMenuInfoArr:[settingMenuInfo] =
    [
        settingMenuInfo(icon: UIImage(named: "组 431")!, title: "系統設定", rightImage: UIImage(named: "273")!),
        settingMenuInfo(icon: UIImage(named: "组 430")!, title: "常見問題說明", rightImage: UIImage(named: "273")!),
        settingMenuInfo(icon: UIImage(named: "组 428")!, title: "聯絡客服與合作提案", rightImage: UIImage(named: "273")!),
        settingMenuInfo(icon: UIImage(named: "组 618")!, title: "服務條款與隱私政策", rightImage: UIImage(named: "273")!),
        settingMenuInfo(icon: UIImage(named: "组 423")!, title: "登出", rightImage: nil)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "會員資料與系統設定"
        setDefaultNavigationBackBtn2()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        tableView.setSeparatorLocation()
        tableView.separatorColor = CommonColor.shared.color5
    }
    
}

extension SettingMenuVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("123")
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
