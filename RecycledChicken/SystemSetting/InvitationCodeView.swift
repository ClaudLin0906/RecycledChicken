//
//  InvitationCodeView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/25.
//

import UIKit

protocol InvitationCodeViewDelegate {
    func comfirmInvitationCode(_ invitationCode:String, finishAction:(()->())?)
}

class InvitationCodeView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var invitationCodeLabelWidth:NSLayoutConstraint!
    
    @IBOutlet weak var invitationCodeTextField:UITextField!
    
    private var originFrame: CGRect?
    
    var delegate:InvitationCodeViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func customInit(){
        loadNibContent()
        invitationCodeLabelWidth.constant = 100
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard(_:)))
        self.addGestureRecognizer(closeTap)
        setupKeyboardNotifications()
    }
    
    @IBAction func cancel(_ sender:UIButton){
        self.removeFromSuperview()
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if originFrame == nil {
            originFrame = self.frame
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let textFieldBottom = max(invitationCodeTextField.convert(invitationCodeTextField.bounds, to: nil).maxY, invitationCodeTextField.convert(invitationCodeTextField.bounds, to: nil).maxY)
            let screenHeight = UIScreen.main.bounds.height
            let overlap = textFieldBottom + keyboardHeight - screenHeight
            if overlap < 0 {
                UIView.animate(withDuration: 0.3) {
                    self.frame.origin.y -= overlap + UIScreen.main.bounds.height * 0.3
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if let originalFrame = originFrame {
            UIView.animate(withDuration: 0.3) {
                self.frame = originalFrame
            }
        }
    }

    @objc private func closeKeyboard(_ tap:UITapGestureRecognizer){
        self.endEditing(true)
    }
    
    @IBAction func comfirm(_ sender:UIButton ) {
        delegate?.comfirmInvitationCode(invitationCodeTextField.text ?? "", finishAction: {
            self.removeFromSuperview()
        })
    }
}
