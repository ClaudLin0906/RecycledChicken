//
//  GetTicketView.swift
//  RecycledChicken
//
//  Created by sj on 2024/6/15.
//

import UIKit

class GetTicketView: UIView, NibOwnerLoadable {

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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1
        layer.cornerRadius = self.frame.height / 2
        layer.borderColor = UIColor.white.cgColor
    }
}
