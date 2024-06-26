//
//  CustomLabel.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/15.
//

import UIKit

@IBDesignable class CustomLabel: UILabel {
    
    @IBInspectable var fontFamily: String = "GenJyuuGothic-Medium"

    @IBInspectable var fontSize: CGFloat = 14.0
    
    @IBInspectable var kernSize: CGFloat = 0
    
    @IBInspectable var lineSpaceSize: CGFloat = 0
    
    override func awakeFromNib() {
        let attrString = NSMutableAttributedString(attributedString: self.attributedText!)
        attrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: self.fontFamily, size: self.fontSize)!, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedString.Key.kern, value: kernSize, range: NSRange(location: 0, length: attrString.length))
        self.attributedText = attrString
    }

}
