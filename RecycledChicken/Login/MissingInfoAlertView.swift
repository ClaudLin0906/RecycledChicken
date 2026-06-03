//
//  MissingInfoAlertView.swift
//  RecycledChicken
//
//  Created by Antigravity on 2026/06/02.
//

import UIKit
import M13Checkbox

class MissingInfoAlertView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var genderSelectionView: GenderSelectionView!
    @IBOutlet weak var privacyCheckBox: M13Checkbox!
    @IBOutlet weak var privacyStackView: UIStackView!
    @IBOutlet weak var confirmBtn: CustomButton!
    
    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "zh_TW")
        return df
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        dp.locale = Locale(identifier: "zh_TW")
        dp.calendar = Calendar(identifier: .gregorian)
        dp.date = dp.calendar.date(from: DateComponents(year: 2000, month: 1, day: 1)) ?? Date()
        return dp
    }()
    
    var onConfirm: ((String, Gender) -> Void)?
    
    var onCancel: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        loadNibContent()
        setupUI()
    }
    
    private func setupUI() {
        setupDatePicker()
        setupPrivacyTap()
        changeLabelsToGray(in: genderSelectionView)
        birthdayTextField.changePlaceholder(placeholder: "請選擇生日", color: .lightGray)
        
        genderSelectionView.onGenderChanged = { [weak self] _ in
            self?.validateInputs()
        }
        validateInputs()
    }
    
    private func changeLabelsToGray(in view: UIView) {
        if let label = view as? UILabel {
            label.textColor = .gray
        }
        for subview in view.subviews {
            changeLabelsToGray(in: subview)
        }
    }
    
    private func validateInputs() {
        let isBirthFilled = !(birthdayTextField.text ?? "").isEmpty
        let isGenderFilled = genderSelectionView.selectedGender != nil
        let isPrivacyAgreed = privacyCheckBox.checkState == .checked
        
        let isValid = isBirthFilled && isGenderFilled && isPrivacyAgreed
        confirmBtn.isEnabled = isValid
        confirmBtn.backgroundColor = isValid ? #colorLiteral(red: 0.2745098039, green: 0.3764705882, blue: 0.3333333333, alpha: 1) : #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
    }
    
    private func setupDatePicker() {
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        birthdayTextField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(doneClick))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneBtn], animated: false)
        birthdayTextField.inputAccessoryView = toolbar
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        birthdayTextField.text = Self.dateFormatter.string(from: sender.date)
        validateInputs()
    }
    
    @objc private func doneClick() {
        if birthdayTextField.text?.isEmpty == true {
            dateChanged(datePicker)
        }
        endEditing(true)
    }
    
    private func setupPrivacyTap() {
        privacyCheckBox.isUserInteractionEnabled = false
        privacyStackView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(privacyTapped))
        privacyStackView.addGestureRecognizer(tap)
    }
    
    @objc private func privacyTapped() {
        let privacyView = PrivacyAlertView(frame: UIScreen.main.bounds)
        privacyView.onAgree = { [weak self] in
            self?.privacyCheckBox.checkState = .checked
            self?.validateInputs()
        }
        privacyView.onCancel = { [weak self] in
            self?.privacyCheckBox.checkState = .unchecked
            self?.validateInputs()
        }
        keyWindow?.addSubview(privacyView)
    }
    
    @IBAction private func confirmTapped(_ sender: Any) {
        guard let birth = birthdayTextField.text, !birth.isEmpty else {
            if let topVC = getTopController() {
                showAlert(VC: topVC, title: nil, message: "生日不能為空", alertAction: nil)
            }
            return
        }
        guard let gender = genderSelectionView.selectedGender else {
            if let topVC = getTopController() {
                showAlert(VC: topVC, title: nil, message: "性別不能為空", alertAction: nil)
            }
            return
        }
        guard privacyCheckBox.checkState == .checked else {
            if let topVC = getTopController() {
                showAlert(VC: topVC, title: nil, message: "請閱讀並同意隱私政策", alertAction: nil)
            }
            return
        }
        
        onConfirm?(birth, gender)
    }
    
    @IBAction private func backTapped(_ sender: Any) {
        onCancel?()
    }
}
