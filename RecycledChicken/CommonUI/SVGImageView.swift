//
//  SVGImageView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/9.
//

import UIKit

protocol SVGImageViewDelegate {
    func tapImageViewHandle(_ svgBackgroundView:UIView, _ imageSVGName:String)
    func tapBackgroundHandle(_ backgroundView:UIView)
}

class SVGImageView: UIView, NibOwnerLoadable {
    
    var delegate:SVGImageViewDelegate?
    
    @IBInspectable var imageSVGName:String = ""
    {
        willSet {
            if newValue != "" {
                svgBackgroundView.isHidden = false
            }
            if newValue == "" {
                svgBackgroundView.isHidden = true
            }
        }
    }
    
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
        addSVG()
    }
    
    func addSVG() {
        if imageSVGName != "" {
            print("svgBackgroundView \(svgBackgroundView.frame.size)")
            let size = self.frame.size.width / 2
            addSVGImageView(svgBackgroundView, size: size, svgImageName: imageSVGName)
        }
    }
    
    @objc private func tapBackgroundHandle(_ sender:UITapGestureRecognizer) {
        delegate?.tapBackgroundHandle(self)
    }
    
    @objc private func tapImageViewHandle(_ sender:UITapGestureRecognizer) {
        delegate?.tapImageViewHandle(svgBackgroundView, imageSVGName)
    }

}
