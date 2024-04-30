//
//  ColorFillTypeTwoView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/4.
//

import UIKit
import Combine
class ColorFillTypeTwoView: UIView, NibOwnerLoadable {
    
    var delegate:ColorFillTypeDelegate?
    
    @IBOutlet weak var bigFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var medFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var smallFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var bottomFillRightChicken:ColorFillImageView!
    
    @IBOutlet weak var fillColorBattery:ColorFillImageView!
    
    @IBOutlet weak var fillColorPaperCup:ColorFillImageView!
    
    @IBOutlet weak var fillColoraluminumCan:ColorFillImageView!
    
    @IBOutlet weak var fillColorBigPET:ColorFillImageView!
    
    private lazy var imageViews:[ColorFillImageView] = [ bottomFillRightChicken, fillColorBattery, fillColorPaperCup, fillColoraluminumCan, fillColorBigPET, smallFillRightChicken, medFillRightChicken, bigFillRightChicken ]
            
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
    
//    private func getKeyName(_ imageViewTag:Int) -> String {
//        var result = ""
//        let target = imageViews.first(where: {$0.tag == imageViewTag})
//        switch target?.tag {
//        case 0:
//            result = UserDefaultKey.shared.bottomFillRightChickenOfColorFillTypeTwoView
//        case 1:
//            result = UserDefaultKey.shared.fillColorBatteryOfColorFillTypeTwoView
//        case 2:
//            result = UserDefaultKey.shared.fillColorPaperCupOfColorFillTypeTwoView
//        case 3:
//            result = UserDefaultKey.shared.fillColoraluminumCanOfColorFillTypeTwoView
//        case 4:
//            result = UserDefaultKey.shared.fillColorBigPETOfColorFillTypeTwoView
//        case 5:
//            result = UserDefaultKey.shared.smallFillRightChickenOfFillTypeTwoView
//        case 6:
//            result = UserDefaultKey.shared.medFillRightChickenOfFillTypeTwoView
//        case 7:
//            result = UserDefaultKey.shared.bigFillRightChickenOfColorFillTypeTwoView
//        default :
//            break
//        }
//        return result
//    }
    
    @objc private func tapImageView(_ tapGesture:UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
            delegate?.tapImage(imageView)
        }
    }
    
    @objc private func tapView(_ tapGesture:UITapGestureRecognizer) {
        delegate?.tapBackground(self)
    }
    
}
