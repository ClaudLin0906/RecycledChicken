//
//  ColorFillTypeOneCellView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/3.
//

import UIKit
protocol ColorFillTypeOneCellViewDelegate {
    func tapImageViewHandle(_ imageView:UIImageView, userdefultKey:String)
    func tapBackgroundHandle(_ backgroundView:UIView, userdefultKey:String)
}

class ColorFillTypeOneCellView: UIView, NibOwnerLoadable {
    
    var delegate:ColorFillTypeOneCellViewDelegate?
    
    @IBInspectable var userdefultKeyOfImage: String = ""
    
    @IBInspectable var userdefultKeyOfBackground: String = ""
        
    @IBInspectable var image: UIImage?
    
    @IBOutlet weak var imageView:UIImageView!
    
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
        if let color = UserDefaults().colorForKey(userdefultKeyOfImage) {
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
        }
        if let color = UserDefaults().colorForKey(userdefultKeyOfBackground) {
            self.backgroundColor = color
        }
    }
    
    private func customInit(){
        loadNibContent()
        let tapBackgroundGesture = UITapGestureRecognizer(target: self, action: #selector(tapBackgroundHandle(_:)))
        addGestureRecognizer(tapBackgroundGesture)
        let tapImageViewGesture = UITapGestureRecognizer(target: self, action: #selector(tapImageViewHandle(_:)))
        imageView.addGestureRecognizer(tapImageViewGesture)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let image = image {
            imageView.image = image
        }
    }
    
    @objc private func tapBackgroundHandle(_ sender:UITapGestureRecognizer) {
        delegate?.tapBackgroundHandle(self, userdefultKey: userdefultKeyOfBackground)
    }
    
    @objc private func tapImageViewHandle(_ sender:UITapGestureRecognizer) {
        if imageView.image != nil {
            delegate?.tapImageViewHandle(imageView, userdefultKey: userdefultKeyOfImage)
        }
        
        if imageView.image == nil {
            delegate?.tapBackgroundHandle(self, userdefultKey: userdefultKeyOfBackground)
        }
    }
    

}
