//
//  CompeleteSignUpView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/3/2.
//

import UIKit

class CompeleteSignUpView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var textField:UITextField!
    {
        didSet {
            let attrString = NSMutableAttributedString(attributedString: oldValue.attributedText!)
            attrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "GenJyuuGothic-Normal", size: 14)!, range: NSMakeRange(0, attrString.length))
            let placeholderColor = #colorLiteral(red: 0.5607843137, green: 0.7411764706, blue: 0.6705882353, alpha: 1)
            oldValue.attributedPlaceholder = NSAttributedString(string: "輸入註冊活動碼", attributes: [NSAttributedString.Key.foregroundColor : placeholderColor])
        }
    }
    
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
