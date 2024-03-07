//
//  IllustratedGuideFirstInfoView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/3/5.
//

import UIKit

protocol IllustratedGuideFirstInfoViewDelegate {
    func rightBtnPress(_ sender:UIButton)
}

class IllustratedGuideFirstInfoView: UIView, NibOwnerLoadable {
    
    var delegate:IllustratedGuideFirstInfoViewDelegate?
    
    @IBOutlet weak var imageView:UIImageView!
    
    @IBOutlet weak var nameLabel:CustomLabel!
    
    @IBOutlet weak var typeLabel:CustomLabel!
    
    @IBOutlet weak var guideLabel:CustomLabel!
    
    @IBOutlet weak var rightBtn:UIButton!

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
        rightBtn.addTarget(self, action: #selector(btnPress(_:)), for: .touchUpInside)
    }
    
    func setInfo(_ image:UIImage, name:String, type:String, guide:String) {
        imageView.image = image
        nameLabel.text = name
        typeLabel.text = type
        guideLabel.text = guide
    }

    @objc private func btnPress(_ sender:UIButton) {
        delegate?.rightBtnPress(sender)
    }
    
}
