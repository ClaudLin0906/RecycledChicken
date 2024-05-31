//
//  ChickeIntroduceView.swift
//  RecycledChicken
//
//  Created by sj on 2024/5/31.
//

import UIKit

class ChickeIntroduceView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var imageView:UIImageView!
    
    @IBOutlet weak var discoverLabel:CustomLabel!
    
    @IBOutlet weak var introduceLabel:CustomLabel!

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
        guard let currentProfileNewInfo = CurrentUserInfo.shared.currentProfileNewInfo, let chickenLevel = currentProfileNewInfo.levelInfo?.chickenLevel else { return }
        let chickenInfo = getIllustratedGuide(chickenLevel)
        discoverLabel.text = "發現「\(chickenInfo.name)」了！"
        imageView.image = chickenInfo.levelImage
        introduceLabel.text = chickenInfo.discover
    }

}
