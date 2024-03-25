//
//  CustomButton.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/15.
//

import UIKit

@IBDesignable class CustomButton: UIButton {

    @IBInspectable var spacing:CGFloat = 3 {
       didSet {
         updateTitleOfLabel()
       }
    }
    
    @IBInspectable var fontSize: CGFloat = 14.0

    @IBInspectable var fontFamily: String = "GenJyuuGothic-Medium"
    
    override func awakeFromNib() {
        if let title = titleLabel, let attributedText = title.attributedText {
            let attrString = NSMutableAttributedString(attributedString: attributedText)
            attrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: self.fontFamily, size: self.fontSize)!, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(3.0), range: NSRange(location: 0, length: attrString.length))
            
            self.titleLabel?.attributedText = attrString
        }
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {

         let attributedTitle = NSAttributedString(
             string: title ?? "",
             attributes: attributes)
         super.setAttributedTitle(attributedTitle, for: state)
    }

   private func updateTitleOfLabel() {
     let states:[UIControl.State] = [.normal, .highlighted, .selected, .disabled]
       for state in states {
         let currentText = super.title(for: state)
         self.setTitle(currentText, for: state)
       }
    }

}
