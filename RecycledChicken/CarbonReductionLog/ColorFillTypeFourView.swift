//
//  ColorFillTypeFourView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/7.
//

import UIKit

class ColorFillTypeFourView: UIView, NibOwnerLoadable {
    
    var delegate:ColorFillTypeDelegate?
    
    @IBOutlet weak var bigFillRightChicken:UIImageView!
    
    @IBOutlet weak var bigFillLeftChicken:UIImageView!
    
    @IBOutlet weak var oneFillRightChicken:UIImageView!
    
    @IBOutlet weak var twoFillRightChicken:UIImageView!
    
    @IBOutlet weak var threeFillRightChicken:UIImageView!
    
    private lazy var imageViews:[UIImageView] = [bigFillRightChicken, bigFillLeftChicken, oneFillRightChicken, twoFillRightChicken, threeFillRightChicken]
    
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
        imageViews.forEach({
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView(_:)))
            $0.addGestureRecognizer(tap)
        })
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
        addGestureRecognizer(tap)
    }
    
    private func getKeyName(_ imageViewTag:Int) -> String {
        var result = ""
        let target = imageViews.first(where: {$0.tag == imageViewTag})
        switch target?.tag {
        case 0:
            result = UserDefaultKey.shared.bigFillRightChickenOfColorFillTypeFourView
        case 1:
            result = UserDefaultKey.shared.bigFillLeftChickenOfColorFillTypeFourView
        case 2:
            result = UserDefaultKey.shared.bigFillLeftChickenOfColorFillTypeFourView
        case 3:
            result = UserDefaultKey.shared.twoFillRightChickenOfColorFillTypeFourView
        case 4:
            result = UserDefaultKey.shared.threeFillRightChickenOfColorFillTypeFourView
        default :
            break
        }
        return result
    }
    
    @objc private func tapImageView(_ tapGesture:UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
            delegate?.tapImage(imageView)
        }
    }
    
    @objc private func tapView(_ tapGesture:UITapGestureRecognizer) {
        delegate?.tapBackground(self)
    }
    
}
