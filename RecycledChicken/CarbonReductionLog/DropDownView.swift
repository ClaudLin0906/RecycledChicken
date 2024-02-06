//
//  DropDownView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/6.
//

import UIKit

class DropDownView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var sortLabel:UILabel!

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
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1)
        self.layer.cornerRadius = self.frame.height / 2
    }

}
