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
    
    @IBAction func confirm(_ sender:CustomButton) {
        var alertMsg = ""
        let activityCode = activityCodeTextField.text
        if activityCode == "" {
            alertMsg += "活動碼不能為空"
        }
        alertMsg = removeWhitespace(from: alertMsg)
        if alertMsg != "" {
            showErrorMSG(alertMsg)
            return
        }
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName + APIUrl.enterActivityCode) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                self.showErrorMSG(errorMSG ?? "")
                return
            }
            let ApiResult = try? JSONDecoder().decode(ApiResult.self, from: data)
            if let status = ApiResult?.status {
                switch status {
                case .success:
                    self.delegate?.comfirmInvitationCode(finishAction: {
                        self.removeFromSuperview()
                    })
                case .failure:
                    self.showErrorMSG(ApiResult?.message ?? "")
                }
            }
        }
    }

    @IBAction func cancel(_ sender:CustomButton) {
        self.delegate?.comfirmInvitationCode(finishAction: {
            self.removeFromSuperview()
        })
    }
}
