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
    
    let datePicker = UIDatePicker()
        
    let rightNow = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "個人賬戶"
        UIInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }
    
    private func UIInit(){
        profileTableView.setSeparatorLocation()
    }
    
    private func createDatePicker(_ textfield:UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed(_:)))
        toolbar.setItems([doneBtn], animated: true)
        datePicker.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: 200)
        textfield.inputAccessoryView = toolbar
        textfield.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc private func donePressed(_ sender:UIBarButtonItem) {
        let components = datePicker.calendar.dateComponents([.day, .month, .year], from: datePicker.date)
        let day = components.day
        let month = components.month
        let year = components.year
        let cells = cellsForTableView(tableView: profileTableView)
        if let birthdayCell = cells.filter({ return $0.tag == 3})[0] as? ProfileTableViewCell {
            birthdayCell.info.text = "\(year!)/\(month!)/\(day!)"
        }
        view.endEditing(true)
    }
    
    private func updateUserInfo( userInfo:ProfileInfo){
        let userInfoDic = try? userInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.updateProfile, parameters: userInfoDic, AuthorizationToken: CommonKey.shared.authToken){ (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            if let data = data {
                self.showProfileUpdateView()
            }
        }
    }
    
    @IBAction func confirm(_ sender:UIButton) {
        var newUserInfo = ProfileInfo(userEmail: "", userName: "", userBirth: "", point: 0, userPhoneNumber: "")
        let cells = cellsForTableView(tableView: profileTableView)
        for cell in cells {
            if let profileTableViewCell = cell as? ProfileTableViewCell {
                if profileTableViewCell.tag == 0 {
                    newUserInfo.userName = profileTableViewCell.info.text ?? ""
                }
                if profileTableViewCell.tag == 1 {
                    newUserInfo.userEmail = profileTableViewCell.info.text ?? ""
                }
                if profileTableViewCell.tag == 2 {
                    newUserInfo.userPhoneNumber = profileTableViewCell.info.text ?? ""
                }
                if profileTableViewCell.tag == 3 {
                    newUserInfo.userBirth = profileTableViewCell.info.text ?? ""
                }
            }
        }
        
        var errorStr = ""
        
        if newUserInfo.userName == "" {
            errorStr += "用戶名稱不能為空"
        }
        
        if newUserInfo.userEmail == "" {
            errorStr += "\nEmail不能為空"
        } else if !validateEmail(text: newUserInfo.userEmail) {
            errorStr += "\nEmail格式不正確"
        }
        
        if newUserInfo.userPhoneNumber == "" {
            errorStr += "\n手機不能為空"
        }else if !validateCellPhone(text: newUserInfo.userPhoneNumber) {
            errorStr += "\n手機格式不正確"
        }
        
        if newUserInfo.userBirth == "" {
            errorStr += "\n生日不能為空"
        }
        
        errorStr = removeWhitespace(from: errorStr)
        guard errorStr == "" else {
            showAlert(VC: self, title: nil, message: errorStr, alertAction: nil)
            return
        }
        updateUserInfo(userInfo: newUserInfo)
        
    }
    
    private func showProfileUpdateView (){
        DispatchQueue.main.async { [self] in
            let profileUpdateView = ProfileUpdateView(frame: view.frame)
            fadeInOutAni(showView: profileUpdateView)
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
        switch row {
        case 0:
            cell.info.text = CurrentUserInfo.shared.currentProfileInfo?.userName
        case 1:
            cell.info.text = CurrentUserInfo.shared.currentProfileInfo?.userEmail
        case 2:
            cell.info.keyboardType = .numberPad
            cell.phoneNumberCheckBox.isHidden = false
            cell.info.isEnabled = false
            cell.info.text = CurrentUserInfo.shared.currentProfileInfo?.userPhoneNumber
        case 3:
            cell.info.placeholder = "2000/11/11"
            cell.info.text = CurrentUserInfo.shared.currentProfileInfo?.userBirth
            cell.phoneNumberCheckBox.isHidden = false
            createDatePicker(cell.info)
        default:
            break
        }
        return cell
    }
    
    
}
