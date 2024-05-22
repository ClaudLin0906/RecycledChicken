//
//  InvitationCodeView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/25.
//

import UIKit

class InvitationCodeView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var invitationCodeLabelWidth:NSLayoutConstraint!
    
    @IBOutlet weak var invitationCodeTextField:UITextField!

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
        invitationCodeLabelWidth.constant = 100
    }
    
    @IBAction func cancel(_ sender:UIButton){
        self.removeFromSuperview()
    }
    
    @IBAction func comfirm(_ sender:UIButton) {
        guard let invitationCode = invitationCodeTextField.text else {
            return
        }
        let inviteRequestInfo = InviteRequestInfo(inviteCode: invitationCode)
        let inviteRequestInfoDic = try? inviteRequestInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName + APIUrl.enterInviteCode, parameters: inviteRequestInfoDic, AuthorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                return
            }
            print("data \( String(data: data, encoding: .utf8) )")
        }
    }
}
