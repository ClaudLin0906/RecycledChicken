//
//  IllustratedGuideFirstInfoView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/3/5.
//

import UIKit

class IllustratedGuideFirstInfoView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var imageView:UIImageView!
    
    @IBOutlet weak var nameLabel:CustomLabel!
    
    @IBOutlet weak var typeLabel:CustomLabel!
    
    @IBOutlet weak var guideLabel:CustomLabel!

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
    
    func setInfo(_ image:UIImage, name:String, type:String, guide:String) {
        imageView.image = image
        nameLabel.text = name
        typeLabel.text = type
        guideLabel.text = guide
    }

}
