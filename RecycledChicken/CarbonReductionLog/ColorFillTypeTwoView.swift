//
//  ColorFillTypeTwoView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/4.
//

import UIKit

class ColorFillTypeTwoView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var minChickenImageView:UIImageView!
    
    @IBOutlet weak var smallChickenImageView:UIImageView!
    
    @IBOutlet weak var medChickenImageView:UIImageView!
    
    @IBOutlet weak var maxChickenImageView:UIImageView!

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
