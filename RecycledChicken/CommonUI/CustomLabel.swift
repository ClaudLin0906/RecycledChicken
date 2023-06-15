//
//  CustomLabel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/15.
//

import UIKit

@IBDesignable class CustomLabel: UILabel {
    
    @IBInspectable var fontFamily: String = "GenJyuuGothic-Normal"

    @IBInspectable var fontSize: CGFloat = 14.0
    
    override func awakeFromNib() {
        let attrString = NSMutableAttributedString(attributedString: self.attributedText!)
        attrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: self.fontFamily, size: self.fontSize)!, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(3.0), range: NSRange(location: 0, length: attrString.length))
        self.attributedText = attrString
    }

}
