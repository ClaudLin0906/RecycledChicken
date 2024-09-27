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
        
    var delegate:SignActivityCodeViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit(){
        loadNibContent()
        setAttributes(activityCodeTextField)
        setAttributes(friendActivityCodeTextField)
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard(_:)))
        self.addGestureRecognizer(closeTap)
    }
    
    private func setAttributes(_ textField:UITextField) {
        let placeHolderColor = #colorLiteral(red: 0.5607843137, green: 0.7411764706, blue: 0.6705882353, alpha: 1)
        let attributes: [NSAttributedString.Key: Any] = [ .font: textField.font?.withSize(15), .foregroundColor:placeHolderColor]
        let attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
    }
    
    @objc private func closeKeyboard(_ tap:UITapGestureRecognizer){
        self.endEditing(true)
    }
    
    private func showErrorMSG(_ error:String) {
        errorMSGLabel.text = error
        errorMSGLabel.isHidden = false
    }
    
    private func enterCodeAction(_ parameters: [String:Any], urlString:String, _ compeletion: @escaping(Bool, String)->()) {
        NetworkManager.shared.requestWithJSONBody(urlString: urlString, parameters: parameters) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                var errorMSG = "發生不明錯誤"
                if let statusCode = statusCode {
                    switch (statusCode, urlString) {
                        case (400, APIUrl.domainName + APIUrl.enterActivityCode):
                            errorMSG = "活動碼不能為空"
                        case (404, APIUrl.domainName + APIUrl.enterActivityCode):
                            errorMSG = "活動碼不正確"
                        case (500, APIUrl.domainName + APIUrl.enterActivityCode):
                            errorMSG = "活動碼處理失敗"
                        case (400, APIUrl.domainName + APIUrl.enterInviteCode):
                            errorMSG = "邀請碼為空"
                        case (404, APIUrl.domainName + APIUrl.enterInviteCode):
                            errorMSG = "邀請碼錯誤"
                        case (403, APIUrl.domainName + APIUrl.enterInviteCode):
                            errorMSG = "邀請碼已經被輸入"
                        default:
                            break
                    }
                }
                compeletion(false, errorMSG)
                return
            }
            compeletion(true, "")
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
                codeInfo = try? InviteCodeInfo(inviteCode: code).asDictionary()
            } else {
                codeInfo = try? ActivityCodeInfo(activityCode: code).asDictionary()
            }
            
            enterCodeAction(codeInfo ?? [:], urlString: APIUrl.domainName + urlString) { result, message in
                errorMSG += message
                group.leave()
            }
        }
        processCode(inviteCode, isInviteCode: true, urlString: APIUrl.enterInviteCode)
        processCode(activityCode, isInviteCode: false, urlString: APIUrl.enterActivityCode)
        group.notify(queue: .main) {
            if errorMSG.isEmpty {
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
