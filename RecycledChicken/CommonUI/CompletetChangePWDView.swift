//
//  CompletetChangePWDView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/3/2.
//

import UIKit

class CompletetChangePWDView: UIView, NibOwnerLoadable {
    
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

}
