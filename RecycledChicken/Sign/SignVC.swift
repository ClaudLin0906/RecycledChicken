//
//  SignVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/7.
//

import UIKit
import M13Checkbox

class SignVC: CustomLoginVC {
    
    @IBOutlet weak var phoneTextfield:UITextField!
    
    @IBOutlet weak var passwordTextfield:UITextField!
    
    @IBOutlet weak var goHomeBtn:CustomButton!
    
    @IBOutlet weak var registerBtn:CustomButton!
    
    @IBOutlet weak var birthdayTextfield: UITextField!
    
    @IBOutlet weak var genderSelectionView: GenderSelectionView!
    
    private let privacyCheckBox = M13Checkbox()
    private let privacyStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        setupDatePicker()
        setupPrivacyCheckbox()
    }
    
    private func UIInit(){
        goHomeBtn.addTarget(self, action: #selector(goSignLoginVC(_:)), for: .touchUpInside)
        if getLanguage() == .english {
            let font = passwordTextfield.font?.withSize(12) ?? UIFont.systemFont(ofSize: 12)
            let attributes: [NSAttributedString.Key: Any] = [ .font: font, .foregroundColor: UIColor.gray]
            let attributedPlaceholder = NSAttributedString(string: passwordTextfield.placeholder ?? "", attributes: attributes)
            passwordTextfield.attributedPlaceholder = attributedPlaceholder
        }
    }
    
    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "zh_TW")
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        birthdayTextfield.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(doneClick))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneBtn], animated: false)
        birthdayTextfield.inputAccessoryView = toolbar
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        birthdayTextfield.text = formatter.string(from: sender.date)
    }
    
    @objc private func doneClick() {
        if birthdayTextfield.text?.isEmpty == true, let datePicker = birthdayTextfield.inputView as? UIDatePicker {
            dateChanged(datePicker)
        }
        view.endEditing(true)
    }
    
    private func goToVerificationCode(phone:String, password:String, birth: String?, gender: Gender? ){
        self.dismiss(animated: true) {
            if let VC = UIStoryboard(name: "VerificationCode", bundle: nil).instantiateViewController(withIdentifier: "VerificationCode") as? VerificationCodeVC, let topVC = getTopController() {
                VC.currentType = .sign
                VC.modalPresentationStyle = .fullScreen
                VC.password = password
                VC.phone = phone
                VC.userBirth = birth
                VC.gender = gender
                topVC.present(VC, animated: true)
            }
        }
    }
    
    @IBAction func sendVerificationCode(_ sender: UIButton) {
        guard let inputs = getValidatedInputs() else { return }
        goToVerificationCode(phone: inputs.phone, password: inputs.password, birth: inputs.birth, gender: inputs.gender)
    }
    
    private func getValidatedInputs() -> (phone: String, password: String, birth: String, gender: Gender)? {
        guard let phone = phoneTextfield.text, !phone.isEmpty else {
            showAlert(VC: self, title: nil, message: "電話不能為空", alertAction: nil)
            return nil
        }
        guard validateCellPhone(text: phone) else {
            showAlert(VC: self, title: nil, message: "電話格式不對", alertAction: nil)
            return nil
        }
        
        guard let password = passwordTextfield.text, !password.isEmpty else {
            showAlert(VC: self, title: nil, message: "密碼不能為空", alertAction: nil)
            return nil
        }
        guard validatePassword(text: password) else {
            showAlert(VC: self, title: nil, message: "密碼格式不對", alertAction: nil)
            return nil
        }
        
        guard let birth = birthdayTextfield.text, !birth.isEmpty else {
            showAlert(VC: self, title: nil, message: "生日不能為空", alertAction: nil)
            return nil
        }
        
        guard let gender = genderSelectionView.selectedGender else {
            showAlert(VC: self, title: nil, message: "性別不能為空", alertAction: nil)
            return nil
        }
        
        guard privacyCheckBox.checkState == .checked else {
            showAlert(VC: self, title: nil, message: "請閱讀並同意隱私政策", alertAction: nil)
            return nil
        }
        
        return (phone, password, birth, gender)
    }
    
    private func setupPrivacyCheckbox() {
        privacyCheckBox.boxType = .square
        privacyCheckBox.stateChangeAnimation = .fill
        privacyCheckBox.tintColor = #colorLiteral(red: 0.8274509804, green: 0.6901960784, blue: 0.4156862745, alpha: 1)
        privacyCheckBox.isUserInteractionEnabled = false
        privacyCheckBox.translatesAutoresizingMaskIntoConstraints = false
        
        let privacyLabel = UILabel()
        privacyLabel.text = "閱讀隱私政策並同意"
        privacyLabel.font = UIFont(name: "GenJyuuGothic-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        privacyLabel.textColor = .black
        privacyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        privacyStackView.axis = .horizontal
        privacyStackView.spacing = 8
        privacyStackView.alignment = .center
        privacyStackView.distribution = .fill
        privacyStackView.translatesAutoresizingMaskIntoConstraints = false
        
        privacyStackView.addArrangedSubview(privacyCheckBox)
        privacyStackView.addArrangedSubview(privacyLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(privacyTapped))
        privacyStackView.addGestureRecognizer(tap)
        privacyStackView.isUserInteractionEnabled = true
        
        view.addSubview(privacyStackView)
        
        var backgroundView: UIView? = nil
        if let oldConstraint = view.constraints.first(where: {
            ($0.firstItem as? UIView == registerBtn && $0.firstAttribute == .top)
        }) {
            backgroundView = oldConstraint.secondItem as? UIView
            oldConstraint.isActive = false
        }
        
        NSLayoutConstraint.activate([
            privacyCheckBox.widthAnchor.constraint(equalToConstant: 18),
            privacyCheckBox.heightAnchor.constraint(equalToConstant: 18),
            
            privacyStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            privacyStackView.topAnchor.constraint(equalTo: backgroundView?.bottomAnchor ?? view.topAnchor, constant: 10),
            registerBtn.topAnchor.constraint(equalTo: privacyStackView.bottomAnchor, constant: 15)
        ])
    }
    
    @objc private func privacyTapped() {
        let privacyView = PrivacyAlertView(frame: UIScreen.main.bounds)
        privacyView.onAgree = { [weak self] in
            self?.privacyCheckBox.checkState = .checked
        }
        privacyView.onCancel = { [weak self] in
            self?.privacyCheckBox.checkState = .unchecked
        }
        keyWindow?.addSubview(privacyView)
    }

}
