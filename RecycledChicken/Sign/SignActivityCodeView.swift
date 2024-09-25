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
    
    private func enterCode(urlString: String, completion: @escaping (Bool, String) -> Void) {
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName + urlString) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                let errorMSG = self.getErrorMessage(for: statusCode, urlString: urlString)
                completion(false, errorMSG)
                return
            }
            completion(true, "")
        }
    }
    
    private func getErrorMessage(for statusCode: Int?, urlString: String) -> String {
        guard let statusCode = statusCode else { return "發生不明錯誤" }
        
        switch (statusCode, urlString) {
        case (400, APIUrl.enterActivityCode):
            return "活動碼不能為空"
        case (404, APIUrl.enterActivityCode):
            return "活動碼不正確"
        case (500, APIUrl.enterActivityCode):
            return "活動碼處理失敗"
        case (400, APIUrl.enterInviteCode):
            return "邀請碼為空"
        case (404, APIUrl.enterInviteCode):
            return "邀請碼錯誤"
        case (403, APIUrl.enterInviteCode):
            return "邀請碼已經被輸入"
        default:
            return "發生不明錯誤"
        }
    }

    @IBAction func confirm(_ sender:CustomButton) {
        guard validateInput() else { return }
        let group = DispatchGroup()
        var errors: [String] = []
        
        group.enter()
        enterCode(urlString: APIUrl.enterActivityCode) { success, error in
            if !success { errors.append(error) }
            group.leave()
        }
        
        if !friendActivityCodeTextField.text!.isEmpty {
            group.enter()
            enterCode(urlString: APIUrl.enterInviteCode) { success, error in
                if !success { errors.append(error) }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if errors.isEmpty {
                self.delegate?.comfirmInvitationCode(finishAction: {
                    self.removeFromSuperview()
                })
            } else {
                self.showErrorMSG(errors.joined(separator: "\n"))
            }
        }
    }
    
    private func validateInput() -> Bool {
        let activityCode = activityCodeTextField.text ?? ""
        if activityCode.isEmpty {
            showErrorMSG("活動碼不能為空")
            return false
        }
        return true
    }

    @IBAction func cancel(_ sender:CustomButton) {
        self.delegate?.comfirmInvitationCode(finishAction: {
            self.removeFromSuperview()
        })
    }
}
