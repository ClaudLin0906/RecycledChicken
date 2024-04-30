//
//  ColorFillTypeFourView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/7.
//

import UIKit

class ColorFillTypeFourView: UIView, NibOwnerLoadable {
    
    var delegate:ColorFillTypeDelegate?
    
    @IBInspectable var userdefultKeyOfBackground: String = ""
    
    @IBOutlet weak var bigFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var bigFillLeftChicken:ColorFillImageView!
    
    @IBOutlet weak var oneFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var twoFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var threeFillRightChicken:ColorFillImageView!
    
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
    
    @objc private func tapImageView(_ tapGesture:UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? ColorFillImageView {
            delegate?.tapImage(imageView, userdefultKey: imageView.userDefaultKey)
        }
    }
    
    @objc private func tapView(_ tapGesture:UITapGestureRecognizer) {
        delegate?.tapBackground(self, userdefultKey: userdefultKeyOfBackground)
    }
    
}
