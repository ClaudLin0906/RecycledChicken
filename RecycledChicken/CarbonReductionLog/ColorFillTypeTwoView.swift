//
//  ColorFillTypeTwoView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/4.
//

import UIKit

class ColorFillTypeTwoView: UIView, NibOwnerLoadable {
    
    var delegate:ColorFillTypeDelegate?
    
    @IBOutlet weak var bigFillRightChicken:UIImageView!
    
    @IBOutlet weak var menFillRightChicken:UIImageView!
    
    @IBOutlet weak var smallFillRightChicken:UIImageView!
    
    @IBOutlet weak var bottomFillRightChicken:UIImageView!
    
    @IBOutlet weak var fillColorBattery:UIImageView!
    
    @IBOutlet weak var fillColorPaperCup:UIImageView!
    
    @IBOutlet weak var fillColoraluminumCan:UIImageView!
    
    @IBOutlet weak var fillColorBigPET:UIImageView!
    
    private lazy var imageViews:[UIImageView] = [bigFillRightChicken, menFillRightChicken, smallFillRightChicken, bottomFillRightChicken, fillColorBattery, fillColorPaperCup, fillColoraluminumCan, fillColorBigPET]
    
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
        if let imageView = tapGesture.view as? UIImageView {
            delegate?.tapImage(imageView)
        }
    }
    
    @objc private func tapView(_ tapGesture:UITapGestureRecognizer) {
        delegate?.tapBackground(self)
    }
    
}
