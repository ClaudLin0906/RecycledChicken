//
//  ColorFillTypeThreeView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/7.
//

import UIKit

class ColorFillTypeThreeView: UIView, NibOwnerLoadable {

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
