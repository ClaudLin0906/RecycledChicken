//
//  ColorFillImageView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/30.
//

import UIKit

class ColorFillImageView: UIImageView {
    
    @IBInspectable var userDefaultKey:String = ""
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let color = UserDefaults().object(forKey: userDefaultKey) as? UIColor {
            self.image = self.image?.withTintColor(color, renderingMode: .alwaysTemplate)
        }
    }
}
