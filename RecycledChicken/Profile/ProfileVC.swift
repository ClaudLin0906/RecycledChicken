//
//  ProfileVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/9.
//

import UIKit

class ProfileVC: CustomVC {
    
    @IBOutlet weak var profileTableView:UITableView!
    
    let profileInfoArr:[String] = ["用戶名稱", "E-mail", "手機號碼", "生日"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "個人賬戶"
        setDefaultNavigationBackBtn2()
        UIInit()
    }
    
    private func UIInit(){
        profileTableView.setSeparatorLocation()
        profileTableView.separatorColor = CommonColor.shared.color5
    }

}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileInfoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
        cell.infoTitle.text = profileInfoArr[indexPath.row]
        return cell
    }
    
    
}
