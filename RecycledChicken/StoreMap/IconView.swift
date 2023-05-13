//
//  IconView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/13.
//

import UIKit

class IconView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var icon:UIView!
    
    @IBOutlet weak var title:UILabel!

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
