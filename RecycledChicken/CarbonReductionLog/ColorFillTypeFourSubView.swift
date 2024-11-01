//
//  ColorFillTypeFourSubView.swift
//  RecycledChicken
//
//  Created by sj on 2024/11/1.
//

import UIKit

class ColorFillTypeFourSubView: UIView, NibOwnerLoadable {

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
