//
//  ColorFillTypeOneCellView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/3.
//

import UIKit

protocol ColorFillTypeOneCellViewDelegate {
    func tapImageViewHandle(_ imageView:UIImageView)
    func tapBackgroundHandle(_ backgroundView:UIView)
}

class ColorFillTypeOneCellView: UIView, NibOwnerLoadable {
    
    var delegate:ColorFillTypeOneCellViewDelegate?
    
    @IBOutlet weak var imageView:UIImageView!
    
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
        imageView.addGestureRecognizer(tapImageViewGesture)
    }
    
    @objc private func tapBackgroundHandle(_ sender:UITapGestureRecognizer) {
        delegate?.tapBackgroundHandle(self)
    }
    
    @objc private func tapImageViewHandle(_ sender:UITapGestureRecognizer) {
        delegate?.tapImageViewHandle(imageView)
    }

}