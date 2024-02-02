//
//  RecycledItemView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/2.
//

import UIKit

class RecycledItemView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var chineNameLabel:CustomLabel!
    
    @IBOutlet weak var iconImageView:UIImageView!
    
    @IBOutlet weak var englishNameLabel:CustomLabel!
    
    @IBOutlet weak var countLabel:UILabel!

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
