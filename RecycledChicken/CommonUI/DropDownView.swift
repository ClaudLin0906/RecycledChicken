//
//  DropDownView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/6.
//

import UIKit

enum DropDownViewType {
    case lightColor
    case darkColor
}

class DropDownView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var sortLabel:UILabel!
    
    @IBOutlet weak var arrowtriangleImageView:UIImageView!
        
    private var type:DropDownViewType = .lightColor
    {
        willSet {
            switch newValue {
            case .lightColor:
                setLightColor()
            case .darkColor:
                setDarkColor()
            }
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
        if let content = self.subviews.first {
            content.backgroundColor = .clear
        }
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1)
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func changeType(_ type:DropDownViewType) {
        self.type = type
    }
    
    func setDefaultTitle(_ title:String) {
        sortLabel.text = title
    }
    
    private func setLightColor() {
        backgroundColor = .white
        sortLabel.textColor = .black
        arrowtriangleImageView.tintColor = CommonColor.shared.color1
    }
    
    private func setDarkColor() {
        backgroundColor = CommonColor.shared.color1
        sortLabel.textColor = .white
        arrowtriangleImageView.tintColor = .white
    }
    
    func setFontSize(_ size:CGFloat) {
        sortLabel.font = sortLabel.font.withSize(size)
    }

}
