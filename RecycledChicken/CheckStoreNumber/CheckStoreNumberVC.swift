//
//  CheckStoreNumberVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2025/8/14.
//

import UIKit
import Kingfisher
class CheckStoreNumberVC: CustomVC {
    
    var myTickertCouponsInfo:MyTickertCouponsInfo? = nil
    
    @IBOutlet weak var itemImageView:UIImageView!
    
    @IBOutlet weak var itemNameLabel:CustomLabel!
    
    @IBOutlet weak var serialNumberLabel:CustomLabel!
    
    @IBOutlet weak var drawTimeLabel:CustomLabel!
    
    @IBOutlet weak var itemInstructionTextView:UITextView!
    
    @IBOutlet weak var storeCodeTextField:UITextField!
    
    @IBOutlet weak var errorMSGLabel:CustomLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "myWallet".localized
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        addValue()
    }
    
    private func addValue() {
        guard let myTickertCouponsInfo = myTickertCouponsInfo else { return }
        
        if let picture = myTickertCouponsInfo.picture, let imageURL = URL(string: picture) {
            itemImageView.kf.setImage(with: imageURL)
        }
        
        itemNameLabel.text = myTickertCouponsInfo.name
        
        if let code = myTickertCouponsInfo.code {
            serialNumberLabel.text = "使用序號\(code)"
        }
        
        if let expire = myTickertCouponsInfo.expire {
            drawTimeLabel.text = "使用期限至\(expire)"
        }
        
        if let instruction = myTickertCouponsInfo.instruction {
            itemInstructionTextView.text = instruction
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
        addKeyboardObservers()
        addDismissKeyboardGesture()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
        resetViewTransformIfNeeded()
    }

    // MARK: - Keyboard Handling
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func addDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func handleKeyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let endFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, let durationNumber = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, let curveNumber = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        else { return }
        let keyboardEndFrameInScreen = endFrameValue.cgRectValue
        let keyboardEndFrame = view.convert(keyboardEndFrameInScreen, from: nil)
        guard let firstResponder = view.findFirstResponder() else {
            animateTransform(to: .identity, duration: durationNumber.doubleValue, curve: curveNumber.intValue)
            return
        }
        let responderFrame = firstResponder.convert(firstResponder.bounds, to: view)
        let responderBottomY = responderFrame.maxY
        let keyboardTopY = keyboardEndFrame.minY
        let padding: CGFloat = 30
        let overlap = max(0, responderBottomY + padding - keyboardTopY)

        if overlap > 0 {
            animateTransform(to: CGAffineTransform(translationX: 0, y: -overlap), duration: durationNumber.doubleValue, curve: curveNumber.intValue)
        } else {
            animateTransform(to: .identity, duration: durationNumber.doubleValue, curve: curveNumber.intValue)
        }
    }

    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        let curve = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue ?? UIView.AnimationCurve.easeInOut.rawValue
        animateTransform(to: .identity, duration: duration, curve: curve)
    }

    private func animateTransform(to transform: CGAffineTransform, duration: TimeInterval, curve: Int) {
        let options = UIView.AnimationOptions(rawValue: UInt(curve << 16))
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.view.transform = transform
        }
    }

    private func resetViewTransformIfNeeded() {
        if view.transform != .identity {
            UIView.animate(withDuration: 0.2) {
                self.view.transform = .identity
            }
        }
    }
    
    @IBAction func checkStoreCode(_ btn:CustomButton) {
        guard let myTickertCouponsInfo = myTickertCouponsInfo, let partnerCode = myTickertCouponsInfo.partner, let storeCodeText = storeCodeTextField.text else { return }
        if partnerCode == storeCodeText {
            
        }
    }
        
}
