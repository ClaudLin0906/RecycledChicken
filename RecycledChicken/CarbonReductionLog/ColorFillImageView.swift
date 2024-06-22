//
//  ColorFillImageView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/30.
//

import UIKit

class ColorFillImageView: UIImageView {
    
    @IBInspectable var userDefaultKey:String = ""
    {
        willSet {
            guard newValue != "" else { return }
            if let color = UserDefaults().colorForKey(newValue) {
                self.image = self.image?.withTintColor(color, renderingMode: .alwaysTemplate)
            }
        }
    }
}
