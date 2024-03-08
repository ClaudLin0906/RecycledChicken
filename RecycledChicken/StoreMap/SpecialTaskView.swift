//
//  SpecialTaskView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/3/8.
//

import UIKit

class SpecialTaskView: UIView, NibOwnerLoadable {

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
