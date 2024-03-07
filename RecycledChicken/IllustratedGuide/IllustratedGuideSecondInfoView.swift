//
//  IllustratedGuideSecondInfoView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/3/6.
//

import UIKit

protocol IllustratedGuideSecondInfoViewDelegate {
    func leftBtnOnCilck(_ sender:UIButton)
}

class IllustratedGuideSecondInfoView: UIView, NibOwnerLoadable {
    
    var delegate:IllustratedGuideSecondInfoViewDelegate?
    
    @IBOutlet weak var nameLabel:CustomLabel!
    
    @IBOutlet weak var typeLabel:CustomLabel!
    
    @IBOutlet weak var guideLabel:CustomLabel!
    
    @IBOutlet weak var leftBtn:UIButton!

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
        leftBtn.addTarget(self, action: #selector(btnPress(_:)), for: .touchUpInside)
    }
    
    func setInfo( _ name:String, type:String, guide:String) {
        nameLabel.text = name
        typeLabel.text = type
        guideLabel.text = guide
    }
    
    @objc private func btnPress(_ sender:UIButton) {
        delegate?.leftBtnOnCilck(sender)
    }
    
}
