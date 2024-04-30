//
//  ColorFillTypeThreeView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/7.
//

import UIKit

class ColorFillTypeThreeView: UIView, NibOwnerLoadable {
    
    var delegate:ColorFillTypeDelegate?
    
    @IBInspectable var userdefultKeyOfBackground: String = ""
    
    @IBOutlet weak var bigFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftTopOneFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftTopTwoFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftTopThreeFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftTopFourFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftBottomOneFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftBottomTwoFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftBottomThreeFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftBottomFourFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var rightBottomOneFillLeftChicken:ColorFillImageView!
    
    @IBOutlet weak var rightBottomTwoFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var rightBottomThreeFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var rightBottomFourFillRightChicken:ColorFillImageView!
    
    private lazy var imageViews:[UIImageView] = [bigFillRightChicken, leftTopOneFillRightChicken, leftTopTwoFillRightChicken, leftTopThreeFillRightChicken, leftTopFourFillRightChicken, leftBottomOneFillRightChicken, leftBottomTwoFillRightChicken, leftBottomThreeFillRightChicken, leftBottomFourFillRightChicken, rightBottomOneFillLeftChicken, rightBottomTwoFillRightChicken, rightBottomThreeFillRightChicken, rightBottomFourFillRightChicken]

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
