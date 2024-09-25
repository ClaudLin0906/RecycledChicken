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
        let placeHolderColor = #colorLiteral(red: 0.5607843137, green: 0.7411764706, blue: 0.6705882353, alpha: 1)
        let attributes: [NSAttributedString.Key: Any] = [ .font: activityCodeTextField.font?.withSize(15), .foregroundColor:placeHolderColor]
        let attributedPlaceholder = NSAttributedString(string: activityCodeTextField.placeholder ?? "", attributes: attributes)
        activityCodeTextField.attributedPlaceholder = attributedPlaceholder
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard(_:)))
        self.addGestureRecognizer(closeTap)
    }
    
    @objc private func closeKeyboard(_ tap:UITapGestureRecognizer){
        self.endEditing(true)
    }
    
    private func showErrorMSG(_ error:String) {
        errorMSGLabel.text = error
        errorMSGLabel.isHidden = false
    }
    
    private func enterActivityCodeAction(_ activityCode:String, _ compeletion: @escaping(Bool, String)->()) {
        let activityCodeInfo = ActivityCodeInfo(activityCode: activityCode)
        let activityCodeInfoDic = try? activityCodeInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName + APIUrl.enterActivityCode, parameters: activityCodeInfoDic) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                var errorMSG = "發生不明錯誤"
                if let statusCode = statusCode {
                    switch statusCode {
                        case 400:
                            errorMSG = "活動碼不能為空"
                        case 404:
                            errorMSG = "活動碼不正確"
                        case 500:
                            errorMSG = "活動碼處理失敗"
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
    
    private func enterInviteCodeAction(_ inviteCode:String,  _ compeletion: @escaping(Bool, String)->()) {
        let inviteCodeInfo = InviteCodeInfo(inviteCode: inviteCode)
        let inviteCodeInfoDic = try? inviteCodeInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName + APIUrl.enterInviteCode, parameters: inviteCodeInfoDic) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                var errorMSG = "發生不明錯誤"
                if let statusCode = statusCode {
                    switch statusCode {
                        case 400:
                            errorMSG = "邀請碼為空"
                        case 404:
                            errorMSG = "邀請碼錯誤"
                        case 403:
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
        guard let activityCode = activityCodeTextField.text, !activityCode.isEmpty else {
            showErrorMSG("活動碼不能為空")
            return
        }
        
        let group = DispatchGroup()
        var activityCodeSuccess = false
        var inviteCodeSuccess = friendActivityCodeTextField.text == "" ? true : false
        var errorMSG = ""
        if !inviteCodeSuccess, let friendActivityCodeText = friendActivityCodeTextField.text {
            group.enter()
            enterInviteCodeAction(friendActivityCodeText) { (result, message) in
                inviteCodeSuccess = result
                errorMSG += message
                group.leave()
            }
        }
        group.enter()
        enterActivityCodeAction(activityCode) { (result, message) in
            activityCodeSuccess = result
            errorMSG += message
            group.leave()
        }
        group.notify(queue: .main) {
            if activityCodeSuccess && inviteCodeSuccess {
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
