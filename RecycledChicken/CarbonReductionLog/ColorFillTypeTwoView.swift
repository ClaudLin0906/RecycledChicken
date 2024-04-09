//
//  ColorFillTypeTwoView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/4.
//

import UIKit

protocol ColorFillTypeTwoViewDelegate {
    func tapImageView(_ svgBackgroundView:UIView, _ imageSVGName:String)
    func tapView(_ v:UIView)
}

class ColorFillTypeTwoView: UIView, NibOwnerLoadable {
    
    var delegate:ColorFillTypeTwoViewDelegate?
    
    @IBOutlet weak var bottomFillRightChickenView:SVGImageView!
    
    @IBOutlet weak var fillColorBatteryView:SVGImageView!
    
    @IBOutlet weak var fillColorPaperCupView:SVGImageView!
    
    @IBOutlet weak var fillColoraluminumCanView:SVGImageView!
    
    @IBOutlet weak var fillColorBigPETView:SVGImageView!
            
    @IBOutlet weak var smallFillRightChickenView:SVGImageView!
    
    @IBOutlet weak var mediumFillRightChickenView:SVGImageView!
    
    @IBOutlet weak var bigFillRightChickenView:SVGImageView!
    
    private lazy var cellViews:[SVGImageView] = [bottomFillRightChickenView, fillColorBatteryView, fillColorPaperCupView, fillColoraluminumCanView, fillColorBigPETView, smallFillRightChickenView, mediumFillRightChickenView, bigFillRightChickenView]

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
        cellViews.forEach({
            $0.delegate = self
        })
    }
}

extension ColorFillTypeTwoView:SVGImageViewDelegate {
    
    func tapImageViewHandle(_ svgBackgroundView: UIView, _ imageSVGName: String) {
        delegate?.tapImageView(svgBackgroundView, imageSVGName)
    }
    
    func tapBackgroundHandle(_ backgroundView: UIView) {
        delegate?.tapView(self)
    }
    
}
