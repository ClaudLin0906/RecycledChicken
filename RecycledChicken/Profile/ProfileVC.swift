//
//  ProfileVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/9.
//

import UIKit

class ProfileVC: CustomVC {
    
    @IBOutlet weak var profileTableView:UITableView!
    
    @IBOutlet weak var chickenLeverLabel:CustomLabel!
    
    let profileInfoArr:[String] = ["用戶名稱", "E-mail", "手機號碼", "生日"]
    
    let datePicker:UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.maximumDate = Date()
        return datePicker
    }()
        
    let rightNow = Date()
    
    var profileUserInfo = CurrentUserInfo.shared.currentProfileInfo
    {
        didSet{
            DispatchQueue.main.async {
                self.profileTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "個人賬戶"
        UIInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
        getUserInfo(VC: self) {
            self.profileUserInfo = CurrentUserInfo.shared.currentProfileInfo
        }
    }
    
    private func UIInit(){
        profileTableView.setSeparatorLocation()
        if let chickenName = getLevelObject()?.chickenName as? String{
            chickenLeverLabel.text = "目前等級為\(chickenName)雞"
        }
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
        let day:String = {
            let day = components.day
            if day! <= 9 {
                return "0\(day ?? 0)"
            }
            return String(day!)
        }()
        let month:String = {
            let month = components.month
            if month! <= 9 {
                return "0\(month ?? 0)"
            }
            return String(month!)
        }()
        let year = components.year
        let cells = cellsForTableView(tableView: profileTableView)
        if let birthdayCell = cells.filter({ return $0.tag == 3})[0] as? ProfileTableViewCell {
            birthdayCell.info.text = "\(year!)/\(month)/\(day)"
            birthdayCell.phoneNumberCheckBox.checkState = .checked
            birthdayCell.info.isEnabled = false
        }
        view.endEditing(true)
    }
    
    func updateUserInfo( userInfo:ProfileInfo){
        let userInfoDic = try? userInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.updateProfile, parameters: userInfoDic, AuthorizationToken: CommonKey.shared.authToken){ (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            if data != nil {
                self.showProfileUpdateView()
            }
        }
    }
    
    @IBAction func confirm(_ sender:UIButton) {
        guard CurrentUserInfo.shared.isGuest == false else { return } 
        var newUserInfo = ProfileInfo(userEmail: "", userName: "", userBirth: "", point: 0, userPhoneNumber: "", experiencePoint: 0)
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
        
//        if newUserInfo.userName == "" {
//            errorStr += "用戶名稱不能為空"
//        }
        
//        if newUserInfo.userEmail == "" {
//            errorStr += "Email不能為空"
//        } else if !validateEmail(text: newUserInfo.userEmail) {
//            errorStr += "Email格式不正確"
//        }
        
        if newUserInfo.userEmail != "" && !validateEmail(text: newUserInfo.userEmail){
            errorStr += "Email格式不正確"
        }
        
        errorStr = removeWhitespace(from: errorStr)
        guard errorStr == "" else {
            showAlert(VC: self, title: nil, message: errorStr, alertAction: nil)
            return
        }
        
        if newUserInfo.userPhoneNumber == "" {
            errorStr += "手機不能為空"
        }else if !validateCellPhone(text: newUserInfo.userPhoneNumber) {
            errorStr += "手機格式不正確"
        }
        
        errorStr = removeWhitespace(from: errorStr)
        guard errorStr == "" else {
            showAlert(VC: self, title: nil, message: errorStr, alertAction: nil)
            return
        }
        
        if newUserInfo.userBirth == "" {
            errorStr += "生日不能為空"
        }
        errorStr = removeWhitespace(from: errorStr)
        guard errorStr == "" else {
            showAlert(VC: self, title: nil, message: errorStr, alertAction: nil)
            return
        }
        
        if profileUserInfo?.userBirth != newUserInfo.userBirth && newUserInfo.userBirth != "" {
            let updateDateAlertView = UpdateDateAlertView(frame: view.frame)
            updateDateAlertView.VC = self
            updateDateAlertView.userInfo = newUserInfo
            keyWindow?.addSubview(updateDateAlertView)
        }else{
            updateUserInfo(userInfo: newUserInfo)
        }
    }
    
    private func showProfileUpdateView() {
        DispatchQueue.main.async { [self] in
            let profileUpdateView = ProfileUpdateView(frame: view.frame)
            fadeInOutAni(showView: profileUpdateView, finishAction: nil)
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
            cell.info.text = profileUserInfo?.userName
            if CurrentUserInfo.shared.isGuest {
                cell.info.isEnabled = false
            }
        case 1:
            cell.info.text = profileUserInfo?.userEmail
            if CurrentUserInfo.shared.isGuest {
                cell.info.isEnabled = false
            }
        case 2:
            cell.info.keyboardType = .numberPad
            cell.phoneNumberCheckBox.isHidden = false
            cell.phoneNumberCheckBox.checkState = .checked
            cell.info.isEnabled = false
            cell.info.text = profileUserInfo?.userPhoneNumber
        case 3:
            cell.info.placeholder = "2000/11/11"
            cell.phoneNumberCheckBox.isHidden = false
            
            if let userBirth = profileUserInfo?.userBirth, userBirth != ""{
                cell.phoneNumberCheckBox.checkState = .checked
                cell.info.isEnabled = false
                cell.info.text = profileUserInfo?.userBirth
            }
            
            if CurrentUserInfo.shared.isGuest {
                cell.info.isEnabled = false
            }
            createDatePicker(cell.info)
        default:
            break
        }
        return cell
    }
    
    
}
