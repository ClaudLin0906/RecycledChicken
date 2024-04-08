//
//  ColorFillTypeOneCellView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/3.
//

import UIKit

protocol ColorFillTypeOneCellViewDelegate {
    func tapImageViewHandle(_ svgBackgroundView:UIView, _ imageSVGName:String)
    func tapBackgroundHandle(_ backgroundView:UIView)
}

class ColorFillTypeOneCellView: UIView, NibOwnerLoadable {
    
    var delegate:ColorFillTypeOneCellViewDelegate?
    
    @IBInspectable var imageSVGName:String = ""
    
    @IBOutlet weak var svgBackgroundView:UIView!

    
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
        let tapBackgroundGesture = UITapGestureRecognizer(target: self, action: #selector(tapBackgroundHandle(_:)))
        addGestureRecognizer(tapBackgroundGesture)
        let tapImageViewGesture = UITapGestureRecognizer(target: self, action: #selector(tapImageViewHandle(_:)))
        svgBackgroundView.addGestureRecognizer(tapImageViewGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageSVGName != "" {
            addSVGImageView(svgBackgroundView, svgImageName: imageSVGName)
        }
    }
    
    @objc private func tapBackgroundHandle(_ sender:UITapGestureRecognizer) {
        delegate?.tapBackgroundHandle(self)
    }
    
    @objc private func tapImageViewHandle(_ sender:UITapGestureRecognizer) {
        delegate?.tapImageViewHandle(svgBackgroundView, imageSVGName)
    }

}
