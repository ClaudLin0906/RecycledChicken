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
    
    @IBInspectable var fontSize: CGFloat = 14.0 {
        didSet {
            updateFont()
        }
    }

    @IBInspectable var fontFamily: String = "GenJyuuGothic-Medium" {
        didSet {
            updateFont()
        }
    }
    
    @IBInspectable var isBold: Bool = false {
        didSet {
            updateFont()
        }
    }
    
    @IBInspectable var isItalic: Bool = false {
        didSet {
            updateFont()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFont()
    }
    
    private func updateFont() {
        var descriptor: UIFontDescriptor
        
        if let customFont = UIFont(name: fontFamily, size: fontSize) {
            descriptor = customFont.fontDescriptor
        } else {
            descriptor = UIFont.systemFont(ofSize: fontSize).fontDescriptor
        }
        
        if isBold {
            descriptor = descriptor.withSymbolicTraits(.traitBold) ?? descriptor
        }
        if isItalic {
            descriptor = descriptor.withSymbolicTraits(.traitItalic) ?? descriptor
        }
        
        let font = UIFont(descriptor: descriptor, size: fontSize)
        titleLabel?.font = font
        
        if let title = titleLabel?.text {
            let attributedString = NSMutableAttributedString(string: title)
            attributedString.addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: title.count))
            setAttributedTitle(attributedString, for: .normal)
        }
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        guard let title = title else {
            super.setAttributedTitle(nil, for: state)
            return
        }

        let font = titleLabel?.font ?? UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .kern: spacing]

        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
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
