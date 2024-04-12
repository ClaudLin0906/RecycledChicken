//
//  ColorFillTypeThreeView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/7.
//

import UIKit

protocol ColorFillTypeThreeViewDelegate {
    func tapThreeViewImage(_ imageView:UIImageView)
    func tapThreeViewBackground(_ backgroundView:UIView)
}


class ColorFillTypeThreeView: UIView, NibOwnerLoadable {
    
    var delegate:ColorFillTypeThreeViewDelegate?
    
    @IBOutlet weak var bigFillRightChicken:UIImageView!
    
    @IBOutlet weak var leftTopOneFillRightChicken:UIImageView!
    
    @IBOutlet weak var leftTopTwoFillRightChicken:UIImageView!
    
    @IBOutlet weak var leftTopThreeFillRightChicken:UIImageView!
    
    @IBOutlet weak var leftTopFourFillRightChicken:UIImageView!
    
    @IBOutlet weak var leftBottomOneFillRightChicken:UIImageView!
    
    @IBOutlet weak var leftBottomTwoFillRightChicken:UIImageView!
    
    @IBOutlet weak var leftBottomThreeFillRightChicken:UIImageView!
    
    @IBOutlet weak var leftBottomFourFillRightChicken:UIImageView!
    
    @IBOutlet weak var rightBottomOneFillRightChicken:UIImageView!
    
    @IBOutlet weak var rightBottomTwoFillRightChicken:UIImageView!
    
    @IBOutlet weak var rightBottomThreeFillRightChicken:UIImageView!
    
    @IBOutlet weak var rightBottomFourFillRightChicken:UIImageView!
    
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
    
    @objc private func tapImageView(_ tapGesture:UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
            delegate?.tapThreeViewImage(imageView)
        }
    }
    
    @objc private func tapView(_ tapGesture:UITapGestureRecognizer) {
        delegate?.tapThreeViewBackground(self)
    }
    
}
