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
    
    @IBOutlet weak var barCodeView:BarCodeView!
    
    @IBOutlet weak var comfirmBtnWidth:NSLayoutConstraint!
    
    private let profileInfoArr:[String] = ["userName".localized, "cellPhoneNumber".localized, "invitationCode".localized, "marketplace".localized]
    
    private let datePicker:UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.maximumDate = Date()
        return datePicker
    }()
        
    private let rightNow = Date()
    
    private var profileUserInfo = CurrentUserInfo.shared.currentProfileNewInfo
    {
        didSet{
            DispatchQueue.main.async {
                self.profileTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "personalAccount".localized
        UIInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
        getUserNewInfo(VC: self) {
            self.profileUserInfo = CurrentUserInfo.shared.currentProfileNewInfo
        }
        if getLanguage() == .english {
            comfirmBtnWidth.constant = 250
        }
    }
    
    private func UIInit(){
        profileTableView.setSeparatorLocation()
        let illustratedGuide = getIllustratedGuide(getChickenLevel())
        chickenLeverLabel.text = "\("currentLevel".localized):\(illustratedGuide.name)"
        barCodeView.setBarCodeValue("0932266860")
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
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            if data != nil {
                self.showProfileUpdateView()
            }
        }
    }
    
    @IBAction func IllustratedGuideBtnPress(_ sender:CustomButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "IllustratedGuide", bundle: Bundle.main).instantiateViewController(identifier: "IllustratedGuide") as? IllustratedGuideVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func confirm(_ sender:CustomButton) {
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
        
        if newUserInfo.userEmail != "" && !validateEmail(text: newUserInfo.userEmail){
            errorStr += "incorrectEmailFormat".localized
        }
        
        errorStr = removeWhitespace(from: errorStr)
        guard errorStr == "" else {
            showAlert(VC: self, title: nil, message: errorStr)
            return
        }
        
        if newUserInfo.userPhoneNumber == "" {
            errorStr += "phoneCannotBeEmpty".localized
        }else if !validateCellPhone(text: newUserInfo.userPhoneNumber) {
            errorStr += "incorrectPhoneNumberFormat".localized
        }
        
        errorStr = removeWhitespace(from: errorStr)
        guard errorStr == "" else {
            showAlert(VC: self, title: nil, message: errorStr)
            return
        }
        
        if newUserInfo.userBirth == "" {
            errorStr += "birthdayCannotBeEmpty".localized
        }
        errorStr = removeWhitespace(from: errorStr)
        guard errorStr == "" else {
            showAlert(VC: self, title: nil, message: errorStr)
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
//            cell.info.text = profileUserInfo?.userEmail
//            if CurrentUserInfo.shared.isGuest {
//                cell.info.isEnabled = false
//            }
            cell.info.keyboardType = .numberPad
            cell.phoneNumberCheckBox.isHidden = false
            cell.phoneNumberCheckBox.checkState = .checked
            cell.info.isEnabled = false
            cell.info.text = profileUserInfo?.userPhoneNumber
        case 2:
            cell.info.isEnabled = false
            cell.info.text = profileUserInfo?.invitCode
        case 3:
            cell.phoneNumberCheckBox.isHidden = false
            cell.phoneNumberCheckBox.checkState = .unchecked
            if let linkedToBuenoMart = profileUserInfo?.linkedToBuenoMart, linkedToBuenoMart {
                cell.phoneNumberCheckBox.checkState = .checked
            }
            cell.info.isEnabled = false
            cell.info.text = "BUENO COOP 連動"
//            cell.info.placeholder = "2000/11/11"
//            cell.phoneNumberCheckBox.isHidden = false
//
//            if let userBirth = profileUserInfo?.userBirth, userBirth != ""{
//                cell.phoneNumberCheckBox.checkState = .checked
//                cell.info.isEnabled = false
//                cell.info.text = profileUserInfo?.userBirth
//            }
//
//            if CurrentUserInfo.shared.isGuest {
//                cell.info.isEnabled = false
//            }
//            createDatePicker(cell.info)
        default:
            break
        }
        return cell
    }
    
    
}
