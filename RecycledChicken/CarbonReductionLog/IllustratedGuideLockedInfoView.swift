//
//  IllustratedGuideLockedInfoView.swift
//  RecycledChicken
//

import UIKit

class IllustratedGuideLockedInfoView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var silhouetteImageView: UIImageView!
    @IBOutlet weak var experienceLabel: CustomLabel!
    
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
    
    func setExperienceText(_ exp: String) {
        experienceLabel.text = "經驗值介紹：\(exp) 回收物進入下一個等級"
    }
}
