//
//  GenderSelectionView.swift
//  RecycledChicken
//
//  Created by Antigravity on 2026/06/02.
//

import UIKit
import M13Checkbox

class GenderSelectionView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var maleCheckBox: M13Checkbox!
    
    @IBOutlet weak var femaleCheckBox: M13Checkbox!
    
    @IBOutlet weak var lgbtqCheckBox: M13Checkbox!
    
    var selectedGender: Gender? {
        get {
            if maleCheckBox.checkState == .checked {
                return .male
            } else if femaleCheckBox.checkState == .checked {
                return .female
            } else if lgbtqCheckBox.checkState == .checked {
                return .LGBTQ
            }
            return nil
        }
        set {
            maleCheckBox.checkState = (newValue == .male) ? .checked : .unchecked
            femaleCheckBox.checkState = (newValue == .female) ? .checked : .unchecked
            lgbtqCheckBox.checkState = (newValue == .LGBTQ) ? .checked : .unchecked
        }
    }
    
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
        setupCheckboxes()
    }
    
    private func setupCheckboxes() {
        [maleCheckBox, femaleCheckBox, lgbtqCheckBox].forEach { cb in
            cb?.boxType = .square
            cb?.stateChangeAnimation = .fill
            cb?.tintColor = #colorLiteral(red: 0.8274509804, green: 0.6901960784, blue: 0.4156862745, alpha: 1)
            cb?.addTarget(self, action: #selector(checkboxChanged(_:)), for: .valueChanged)
        }
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
}
