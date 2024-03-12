//
//  InvitationCodeView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/25.
//

import UIKit

class InvitationCodeView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var invitationCodeLabelWidth:NSLayoutConstraint!

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
}
