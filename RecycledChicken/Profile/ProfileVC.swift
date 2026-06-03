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
    
    @IBOutlet weak var profileImageView:UIImageView!
    
    private let profileInfoArr:[String] = [
        "userName".localized,
        "cellPhoneNumber".localized,
        "birthday".localized,
        "gender".localized,
        "email".localized,
        "invitationCode".localized,
        "marketplace".localized
    ]

    private let datePicker:UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.maximumDate = Date()
        datePicker.locale = Locale(identifier: "zh_TW")
        datePicker.calendar = Calendar(identifier: .gregorian)
        return datePicker
    }()
        
    private let rightNow = Date()

    private func getRequiredFieldTitle(for title: String) -> NSAttributedString {
        let asterisk = " *"
        let fullText = title + asterisk
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: asterisk)
        if range.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        }
        return attributedString
    }
    
    private func getFieldTitle(for row: Int) -> NSAttributedString {
        let title = profileInfoArr[row]
        let requiredRows = [0, 1, 2, 3]
        if requiredRows.contains(row) {
            return getRequiredFieldTitle(for: title)
        } else {
            return NSAttributedString(string: title)
        }
    }
    
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
        getUserNewInfo(VC: self) { [weak self] in
            self?.profileUserInfo = CurrentUserInfo.shared.currentProfileNewInfo
        }
        if getLanguage() == .english {
            comfirmBtnWidth.constant = 250
        }
    }
    
    private func UIInit(){
        profileTableView.setSeparatorLocation()
        let illustratedGuide = getIllustratedGuide(getChickenLevel())
        chickenLeverLabel.text = "\("currentLevel".localized):\(illustratedGuide.name)"
        profileImageView.image = illustratedGuide.iconImage
        barCodeView.setBarCodeValue(CurrentUserInfo.shared.currentAccountInfo.userPhoneNumber)
    }
    
    private func createDatePicker(_ textfield:UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(donePressed(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneBtn], animated: true)
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
        if let birthdayCell = cells.first(where: { $0.tag == 2 }) as? ProfileTableViewCell {
            birthdayCell.info.text = "\(year!)/\(month)/\(day)"
        }
        self.profileUserInfo?.userBirth = "\(year!)/\(month)/\(day)"
        view.endEditing(true)
    }
    
    func updateUserInfo(_ profilePostInfo: ProfilePostInfo) {
        let profilePostInfoDic = try? profilePostInfo.asDictionary()
        NetworkManager.shared.post(url: APIUrl.domainName + APIUrl.updateProfile,
                                    parameters: profilePostInfoDic,
                                    authorizationToken: CommonKey.shared.authToken,
                                    responseType: ApiResult.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let apiResult):
                    if let status = apiResult.status {
                        switch status {
                        case .success:
                            self?.showProfileUpdateView()
                        case .failure:
                            showAlert(VC: self, title: apiResult.message ?? "error".localized)
                        }
                    } else {
                        showAlert(VC: self, title: "error".localized)
                    }
                case .failure(let error):
                    self?.handleNetworkError(error)
                }
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
        let cells = cellsForTableView(tableView: profileTableView)
        var userName = profileUserInfo?.userName ?? ""
        var userBirth = profileUserInfo?.userBirth ?? ""
        var genderStr = profileUserInfo?.gender?.rawValue ?? ""
        let userEmail = profileUserInfo?.userEmail ?? ""
        
        for cell in cells {
            if let profileTableViewCell = cell as? ProfileTableViewCell {
                if profileTableViewCell.tag == 0 {
                    userName = profileTableViewCell.info.text ?? ""
                }
                if profileTableViewCell.tag == 2 {
                    userBirth = profileTableViewCell.info.text ?? ""
                }
            } else if let genderCell = cell as? ProfileGenderTableViewCell {
                genderStr = genderCell.genderSelectionView.selectedGender?.rawValue ?? ""
            }
        }
        
        if userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert(VC: self, title: "nameCannotBeEmpty".localized)
            return
        }
        if userBirth.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert(VC: self, title: "birthdayCannotBeEmpty".localized)
            return
        }
        if genderStr.isEmpty {
            showAlert(VC: self, title: "genderCannotBeEmpty".localized)
            return
        }
        
        let profilePostInfo = ProfilePostInfo(userName: userName, userEmail: userEmail, userBirth: userBirth, gender: genderStr)
        updateUserInfo(profilePostInfo)
    }
    
    private func showProfileUpdateView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let profileUpdateView = ProfileUpdateView(frame: view.frame)
            fadeInOutAni(showView: profileUpdateView, finishAction: nil)
        }
    }

}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileInfoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileGenderTableViewCell.identifier, for: indexPath) as! ProfileGenderTableViewCell
            cell.infoTitle.attributedText = getFieldTitle(for: row)
            if let gender = profileUserInfo?.gender {
                cell.genderSelectionView.selectedGender = gender
            } else {
                cell.genderSelectionView.selectedGender = nil
            }
            cell.genderSelectionView.onGenderChanged = { [weak self] selectedGender in
                self?.profileUserInfo?.gender = selectedGender
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
            cell.tag = row
            cell.infoTitle.attributedText = getFieldTitle(for: row)
            switch row {
            case 0:
                cell.info.text = profileUserInfo?.userName
                if CurrentUserInfo.shared.isGuest {
                    cell.info.isEnabled = false
                }
            case 1:
                if let profileUserInfo = profileUserInfo, let userPhoneNumber = profileUserInfo.userPhoneNumber, userPhoneNumber != "" {
                    cell.info.keyboardType = .numberPad
                    cell.phoneNumberCheckBox.isHidden = false
                    cell.phoneNumberCheckBox.checkState = .checked
                    cell.info.isEnabled = false
                    cell.info.text = profileUserInfo.userPhoneNumber
                }
            case 2:
                cell.info.text = profileUserInfo?.userBirth
                cell.info.placeholder = "2000/11/11"
                if CurrentUserInfo.shared.isGuest {
                    cell.info.isEnabled = false
                } else {
                    createDatePicker(cell.info)
                }
            case 4:
                cell.info.text = profileUserInfo?.userEmail
                cell.info.isEnabled = false
            case 5:
                if let profileUserInfo = profileUserInfo, let inviteCode = profileUserInfo.inviteCode, inviteCode != "" {
                    cell.info.isEnabled = false
                    cell.info.text = inviteCode
                    cell.delegate = self
                }
            case 6:
                cell.phoneNumberCheckBox.isHidden = false
                cell.phoneNumberCheckBox.checkState = .unchecked
                if let linkedToBuenoMart = profileUserInfo?.linkedToBuenoMart, linkedToBuenoMart {
                    cell.phoneNumberCheckBox.checkState = .checked
                }
                cell.info.isEnabled = false
                cell.info.text = "BUENO COOP 連動"
            default:
                break
            }
            return cell
        }
    }
    
    
}


extension ProfileVC: ProfileTableViewCellDelegate {
    
    func longPress(_ gesture: UILongPressGestureRecognizer, inviteCode: String?) {
        guard let inviteCode = inviteCode, inviteCode != "" else { return }
        UIPasteboard.general.string = inviteCode
        showAlert(VC: self, title: "copySuccess".localized)
    }
    
}
