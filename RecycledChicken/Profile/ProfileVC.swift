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
    
    struct profileInfo {
        var userName:String
        var Email:String
        var cellPhone:String
        var birthday:String
    }
    
    var currentProfileInfo = profileInfo(userName: "", Email: "", cellPhone: "", birthday: "")
    
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
    
    @IBAction func confirm(_ sender:UIButton) {
        let cells = cellsForTableView(tableView: profileTableView)
        for cell in cells {
            if let profileTableViewCell = cell as? ProfileTableViewCell {
                if profileTableViewCell.tag == 0 {
                    currentProfileInfo.userName = profileTableViewCell.info.text ?? ""
                }
                if profileTableViewCell.tag == 1 {
                    currentProfileInfo.Email = profileTableViewCell.info.text ?? ""
                }
                if profileTableViewCell.tag == 2 {
                    currentProfileInfo.cellPhone = profileTableViewCell.info.text ?? ""
                }
                if profileTableViewCell.tag == 3 {
                    currentProfileInfo.birthday = profileTableViewCell.info.text ?? ""
                }
            }
        }
        
        var error = false
        var errorStr = ""
        
        if currentProfileInfo.userName == "" {
            error = true
            errorStr += "用戶名稱不能為空"
        }
        
        if currentProfileInfo.Email == "" {
            error = true
            errorStr += "Email不能為空"
        } else if validateEmail(text: currentProfileInfo.Email) {
            error = true
            errorStr += "Email格式不正確"
        }
        
        if currentProfileInfo.cellPhone == "" {
            error = true
            errorStr += "手機不能為空"
        }else if validateCellPhone(text: currentProfileInfo.cellPhone) {
            error = true
            errorStr += "手機格式不正確"
        }
        
        if currentProfileInfo.birthday == "" {
            error = true
            errorStr += "生日不能為空"
        }
        
        if !error {
            print("發生錯誤 \(errorStr)")
            return
        }
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
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
        cell.tag = row
        cell.infoTitle.text = profileInfoArr[row]
        return cell
    }
    
    
}
