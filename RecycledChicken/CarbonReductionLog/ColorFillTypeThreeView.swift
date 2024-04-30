//
//  ColorFillTypeThreeView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/7.
//

import UIKit

class ColorFillTypeThreeView: UIView, NibOwnerLoadable {
    
    var delegate:ColorFillTypeDelegate?
    
    @IBOutlet weak var bigFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftTopOneFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftTopTwoFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftTopThreeFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftTopFourFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftBottomOneFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftBottomTwoFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftBottomThreeFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var leftBottomFourFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var rightBottomOneFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var rightBottomTwoFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var rightBottomThreeFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var rightBottomFourFillRightChicken:ColorFillImageView!
    
    private lazy var imageViews:[UIImageView] = [bigFillRightChicken, leftTopOneFillRightChicken, leftTopTwoFillRightChicken, leftTopThreeFillRightChicken, leftTopFourFillRightChicken, leftBottomOneFillRightChicken, leftBottomTwoFillRightChicken, leftBottomThreeFillRightChicken, leftBottomFourFillRightChicken, rightBottomOneFillRightChicken, rightBottomTwoFillRightChicken, rightBottomThreeFillRightChicken, rightBottomFourFillRightChicken]

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
            result = UserDefaultKey.shared.bigFillRightChickenOfColorFillTypeThreeView
        case 1:
            result = UserDefaultKey.shared.leftTopOneFillRightChickenOfColorFillTypeThreeView
        case 2:
            result = UserDefaultKey.shared.leftTopTwoFillRightChickenOfColorFillTypeThreeView
        case 3:
            result = UserDefaultKey.shared.leftTopThreeFillRightChickenOfColorFillTypeThreeView
        case 4:
            result = UserDefaultKey.shared.leftTopFourFillRightChickenOfColorFillTypeThreeView
        case 5:
            result = UserDefaultKey.shared.leftBottomOneFillRightChickenOfColorFillTypeThreeView
        case 6:
            result = UserDefaultKey.shared.leftBottomThreeFillRightChickenOfColorFillTypeThreeView
        case 7:
            result = UserDefaultKey.shared.leftBottomTwoFillRightChickenOfColorFillTypeThreeView
        case 8:
            result = UserDefaultKey.shared.leftBottomFourFillRightChickenOfColorFillTypeThreeView
        case 9:
            result = UserDefaultKey.shared.rightBottomOneFillRightChickenOfColorFillTypeThreeView
        case 10:
            result = UserDefaultKey.shared.rightBottomTwoFillRightChickenOfColorFillTypeThreeView
        case 11:
            result = UserDefaultKey.shared.rightBottomThreeFillRightChickenOfColorFillTypeThreeView
        case 12:
            result = UserDefaultKey.shared.rightBottomFourFillRightChickenOfColorFillTypeThreeView
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
