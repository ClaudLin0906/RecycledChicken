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
    
    let datePicker = UIDatePicker()
        
    let rightNow = Date()
    
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
            birthdayCell.info.text = "\(year!)-\(month!)-\(day!)"
        }
        view.endEditing(true)
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
        } else if !validateEmail(text: currentProfileInfo.Email) {
            error = true
            errorStr += "Email格式不正確"
        }
        
        if currentProfileInfo.cellPhone == "" {
            error = true
            errorStr += "手機不能為空"
        }else if !validateCellPhone(text: currentProfileInfo.cellPhone) {
            error = true
            errorStr += "手機格式不正確"
        }
        
        if currentProfileInfo.birthday == "" {
            error = true
            errorStr += "生日不能為空"
        }
        
//        if error {
//            print("發生錯誤 \(errorStr)")
//            return
//        }
        
        showProfileUpdateView()
        
    }
    
    func showProfileUpdateView (){
        DispatchQueue.main.async { [self] in
            let profileUpdateView = ProfileUpdateView(frame: view.frame)
            profileUpdateView.alpha = 0
            view.addSubview(profileUpdateView)
            UIView.animate(withDuration: 1, delay: 0) {
                profileUpdateView.alpha = 1
            } completion: { _ in
                UIView.animate(withDuration: 1, delay: 0) {
                    profileUpdateView.alpha = 0
                } completion: { _ in
                    profileUpdateView.removeFromSuperview()
                }
            }
        }
    }
    
    private func showSignLoginVC(){
        if let VC = UIStoryboard(name: "SignLogin", bundle: nil).instantiateViewController(withIdentifier: "SignLogin") as? SignLoginVC {
            VC.modalPresentationStyle = .fullScreen
            present(VC, animated: false)
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
        if row == 3 {
            createDatePicker(cell.info)
        }
        return cell
    }
    
    
}
