//
//  RecycledItemView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/5.
//

import UIKit

class RecycledItemView: UIView, NibOwnerLoadable {

    @IBOutlet weak var chineNameLabel:CustomLabel!
    
    @IBOutlet weak var iconImageView:UIImageView!
    
    @IBOutlet weak var englishNameLabel:CustomLabel!
    
    @IBOutlet weak var countLabel:UILabel!
    
    @IBOutlet weak var chineNameLabelHeight:NSLayoutConstraint!
    
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
    
    func setInfo(_ sort:RecyceledSort) {
        let info = sort.getInfo()
        chineNameLabel.text = info.chineseName
        englishNameLabel.text = info.englishName
        iconImageView.image = UIImage(named: info.iconName)
        if getLanguage() == .english {
            englishNameLabel.isHidden = true
            chineNameLabelHeight.constant = 40
            chineNameLabel.font = chineNameLabel.font.withSize(9)
        }
    }
    
    func setAmount(_ count:Int) {
        countLabel.text = String(count)
    }

}
