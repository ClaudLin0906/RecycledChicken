//
//  IllustratedGuideSecondInfoView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/3/6.
//

import UIKit

class IllustratedGuideSecondInfoView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var nameLabel:CustomLabel!
    
    @IBOutlet weak var typeLabel:CustomLabel!

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
