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
    
    private var chichenLevel:Int?
    
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
