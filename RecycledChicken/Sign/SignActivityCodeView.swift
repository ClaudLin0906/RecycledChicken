//
//  SignActivityCodeView.swift
//  RecycledChicken
//
//  Created by sj on 2024/6/1.
//

import UIKit

protocol SignActivityCodeViewDelegate {
    func comfirmInvitationCode(finishAction:(()->())?)
}

class SignActivityCodeView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var activityCodeTextField:UITextField!
    
    @IBOutlet weak var friendActivityCodeTextField:UITextField!
    
    @IBOutlet weak var errorMSGLabel:CustomLabel!
    
    private var originFrame: CGRect?
    
    var delegate:SignActivityCodeViewDelegate?
    
    private var phoneNumber = ""
    
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
    
    func setUserID(_ phoneNumber:String) {
        self.phoneNumber = phoneNumber
    }
    
    private func customInit(){
        loadNibContent()
        setAttributes(activityCodeTextField)
        setAttributes(friendActivityCodeTextField)
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard(_:)))
        self.addGestureRecognizer(closeTap)
        setupKeyboardNotifications()
    }
    
    private func setAttributes(_ textField:UITextField) {
        let placeHolderColor = #colorLiteral(red: 0.5607843137, green: 0.7411764706, blue: 0.6705882353, alpha: 1)
        let attributes: [NSAttributedString.Key: Any] = [ .font: textField.font?.withSize(15), .foregroundColor:placeHolderColor]
        let attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
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
            let textFieldBottom = max(activityCodeTextField.convert(activityCodeTextField.bounds, to: nil).maxY, friendActivityCodeTextField.convert(friendActivityCodeTextField.bounds, to: nil).maxY)
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
    
    private func showErrorMSG(_ error:String) {
        errorMSGLabel.text = error
        errorMSGLabel.isHidden = false
    }
    
    private func enterCodeAction(_ parameters: [String: Any], urlString: String, _ completion: @escaping (Bool, String) -> ()) {
        NetworkManager.shared.post(url: urlString,
                                    parameters: parameters,
                                    authorizationToken: "",
                                    responseType: ApiResult.self) { result in
            switch result {
            case .success:
                completion(true, "")
            case .failure(let error):
                var errorMSG = "發生不明錯誤"
                if case .httpError(_, let message) = error, let msg = message {
                    errorMSG = msg
                } else if case .decodingError = error {
                    // 嘗試從錯誤中提取訊息
                    errorMSG = error.localizedDescription
                }
                completion(false, errorMSG)
            }
        }
    }
    
    @IBAction func confirm(_ sender:CustomButton) {
        guard let activityCode = activityCodeTextField.text, let inviteCode = friendActivityCodeTextField.text, !activityCode.isEmpty || !inviteCode.isEmpty else {
            showErrorMSG("活動碼或是邀請碼要擇一填寫")
            return
        }
        let group = DispatchGroup()
        var errorMSG = ""
        func processCode(_ code: String, isInviteCode: Bool, urlString: String) {
            guard !code.isEmpty else { return }
            
            group.enter()
            let codeInfo: [String: Any]?
            if isInviteCode {
                codeInfo = try? InviteCodeInfo(userID: phoneNumber, inviteCode: code).asDictionary()
            } else {
                codeInfo = try? ActivityCodeInfo(userID: phoneNumber, activityCode: code).asDictionary()
            }
            enterCodeAction(codeInfo ?? [:], urlString: APIUrl.domainName + urlString) { result, message in
                errorMSG += message
                group.leave()
            }
        }
        processCode(inviteCode, isInviteCode: true, urlString: APIUrl.enterInviteCode)
        processCode(activityCode, isInviteCode: false, urlString: APIUrl.enterActivityCode)
        group.notify(queue: .main) {
            if errorMSG.isEmpty || errorMSG.contains("重複") {
                self.delegate?.comfirmInvitationCode(finishAction: {
                    self.removeFromSuperview()
                })
            } else {
                self.showErrorMSG(errorMSG)
            }
        }
    }
    
    @IBAction func cancel(_ sender:CustomButton) {
        self.delegate?.comfirmInvitationCode(finishAction: {
            self.removeFromSuperview()
        })
    }
}
