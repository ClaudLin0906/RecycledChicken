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
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var genderSelectionView: GenderSelectionView!
    
    @IBOutlet weak var privacyCheckBox: M13Checkbox!
    
    @IBOutlet weak var privacyStackView: UIStackView!
    
    @IBOutlet weak var confirmBtn: CustomButton!
    
    @IBOutlet weak var backBtn: CustomButton!
    
    private let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        dp.locale = Locale(identifier: "zh_TW")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        if let defaultDate = formatter.date(from: "2000/01/01") {
            dp.date = defaultDate
        }
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
        setupButtons()
        birthdayTextField.textColor = .gray
        birthdayTextField.attributedPlaceholder = NSAttributedString(
            string: "生日",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        genderLabel.textColor = .gray
        
        genderSelectionView.subviews.forEach { subview in
            changeLabelsToGray(in: subview)
        }
    }
    
    private func changeLabelsToGray(in view: UIView) {
        if let label = view as? UILabel {
            label.textColor = .gray
        }
        for subview in view.subviews {
            changeLabelsToGray(in: subview)
        }
    }
    
    private func setupDatePicker() {
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        birthdayTextField.inputView = datePicker
        birthdayTextField.tintColor = .clear
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(doneClick))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneBtn], animated: false)
        birthdayTextField.inputAccessoryView = toolbar
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        birthdayTextField.text = formatter.string(from: sender.date)
    }
    
    @objc private func doneClick() {
        if birthdayTextField.text?.isEmpty == true {
            dateChanged(datePicker)
        }
        endEditing(true)
    }
    
    private func setupPrivacyTap() {
        privacyCheckBox.boxType = .square
        privacyCheckBox.stateChangeAnimation = .fill
        privacyCheckBox.tintColor = #colorLiteral(red: 0.8274509804, green: 0.6901960784, blue: 0.4156862745, alpha: 1)
        privacyCheckBox.isUserInteractionEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(privacyTapped))
        privacyStackView.addGestureRecognizer(tap)
    }
    
    @objc private func privacyTapped() {
        let privacyView = PrivacyAlertView(frame: UIScreen.main.bounds)
        privacyView.onAgree = { [weak self] in
            self?.privacyCheckBox.checkState = .checked
        }
        privacyView.onCancel = { [weak self] in
            self?.privacyCheckBox.checkState = .unchecked
        }
        if let topVC = getTopController() {
            topVC.view.addSubview(privacyView)
        }
    }
    
    private func setupButtons() {
        confirmBtn.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    @objc private func confirmTapped() {
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
    
    @objc private func backTapped() {
        onCancel?()
    }
}
