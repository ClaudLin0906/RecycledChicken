//
//  ReSendVerificationCodeView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/1/31.
//

import UIKit

class ReSendVerificationCodeView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var reciprocalLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        loadNibContent()
        setCornerRadius()
    }
    
    private func setCornerRadius() {
        if let contentView = self.subviews.first {
            contentView.layer.cornerRadius = self.frame.height / 2
        }
    }
}
