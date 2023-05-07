//
//  PasswordTextField.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/7.
//

import UIKit

class PasswordTextField: UITextField{
    
    let imageIconView:UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = CommonColor.shared.color10
        return imageView
    }()
    
    var iconClick = false {
        didSet{
            if oldValue {
                imageIconView.image = UIImage(systemName: "eye.slash")
                self.isSecureTextEntry = true
            }else{
                imageIconView.image = UIImage(systemName: "eye")
                self.isSecureTextEntry = false
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit(){        
        if let image = UIImage(systemName: "eye.slash") {
            let size =  CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            imageIconView.image = image
            imageIconView.frame = size
            let contentView = UIView()
            contentView.frame = size
            contentView.addSubview(imageIconView)
            self.rightView = contentView
            self.rightViewMode = .always
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageIconView.isUserInteractionEnabled = true
            imageIconView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @objc private func imageTapped( _ tapGestureRecognizer:UITapGestureRecognizer){
        iconClick = !iconClick
    }
    
}
