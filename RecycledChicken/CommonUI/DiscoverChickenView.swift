//
//  DiscoverChickenView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/5/2.
//

import UIKit

class DiscoverChickenView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var chickenImageView:UIImageView!
    
    @IBOutlet weak var chickenTitleLabel:CustomLabel!
    
    @IBOutlet weak var chickenGuideLabel:CustomLabel!
    
    private var chichenLevel:IllustratedGuideModelLevel?
    {
        willSet {
            if let newValue = newValue {
                setChichenLevel(newValue)
            }
        }
    }
    
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
    
    private func setChichenLevel(_ level:IllustratedGuideModelLevel) {
        self.chichenLevel = level
        let illustratedGuide = getIllustratedGuide(level)
        chickenImageView.image = illustratedGuide.levelImage
        chickenTitleLabel.text = illustratedGuide.name
        chickenGuideLabel.text = illustratedGuide.guide
    }

}
