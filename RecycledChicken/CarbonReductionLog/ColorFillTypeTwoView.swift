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
    
    var colorFillView:ColorFillView = .ColorFillTypeTwoView
    
    @IBInspectable var userdefultKeyOfBackground: String = ""
    
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let color = UserDefaults().colorForKey(userdefultKeyOfBackground) {
            self.backgroundColor = color
        }
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
            delegate?.tapImage(imageView, userdefultKey: imageView.userDefaultKey, colorFillView: colorFillView)
        }
    }
    
    @objc private func tapView(_ tapGesture:UITapGestureRecognizer) {
        delegate?.tapBackground(self, userdefultKey: userdefultKeyOfBackground, colorFillView: colorFillView)
    }
    
}
