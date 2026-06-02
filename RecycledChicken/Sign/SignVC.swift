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
    
    @IBOutlet weak var birthdayTextfield: UITextField!
    
    @IBOutlet weak var maleCheckBox: M13Checkbox!
    
    @IBOutlet weak var femaleCheckBox: M13Checkbox!
    
    @IBOutlet weak var lgbtqCheckBox: M13Checkbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        setupDatePicker()
        setupCheckboxes()
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
    
    private func setupCheckboxes() {
        [maleCheckBox, femaleCheckBox, lgbtqCheckBox].forEach { cb in
            cb?.boxType = .square
            cb?.stateChangeAnimation = .fill
            cb?.tintColor = UIColor(red: 0.827, green: 0.690, blue: 0.416, alpha: 1.0)
            cb?.addTarget(self, action: #selector(checkboxChanged(_:)), for: .valueChanged)
        }
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
    
    @objc private func checkboxChanged(_ sender: M13Checkbox) {
        guard sender.checkState == .checked else { return }
        if sender == maleCheckBox {
            femaleCheckBox.checkState = .unchecked
            lgbtqCheckBox.checkState = .unchecked
        } else if sender == femaleCheckBox {
            maleCheckBox.checkState = .unchecked
            lgbtqCheckBox.checkState = .unchecked
        } else if sender == lgbtqCheckBox {
            maleCheckBox.checkState = .unchecked
            femaleCheckBox.checkState = .unchecked
        }
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
    
    private func getValidatedInputs() -> (phone: String, password: String, birth: String?, gender: Gender)? {
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
        
        let birth = birthdayTextfield.text?.isEmpty == false ? birthdayTextfield.text : nil
        
        let gender: Gender
        if maleCheckBox.checkState == .checked {
            gender = .male
        } else if femaleCheckBox.checkState == .checked {
            gender = .female
        } else if lgbtqCheckBox.checkState == .checked {
            gender = .LGBTQ
        } else {
            showAlert(VC: self, title: nil, message: "性別不能為空", alertAction: nil)
            return nil
        }
        
        return (phone, password, birth, gender)
    }

}
