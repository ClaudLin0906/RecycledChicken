//
//  CompleteStoreSuccessView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2025/8/14.
//

import UIKit

class CompleteStoreSuccessView: UIView, NibOwnerLoadable {

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
