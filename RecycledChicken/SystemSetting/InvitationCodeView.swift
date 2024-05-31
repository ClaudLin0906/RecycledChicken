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
    
    var delegate:InvitationCodeViewDelegate?

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
    
    @IBAction func comfirm(_ sender:UIButton ) {
        delegate?.comfirmInvitationCode(invitationCodeTextField.text ?? "", finishAction: {
            self.removeFromSuperview()
        })
    }
}
