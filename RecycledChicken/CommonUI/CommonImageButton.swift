//
//  CommonImageButton.swift
//  futures
//
//  Created by Claud on 2023/4/17.
//

import UIKit

class CommonImageButton: UIButton {
    
    var newImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")!
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var newTitLabel:UILabel = {
        let label = UILabel()
        label.font = titleLabel?.font
        label.textAlignment = .left
        label.textColor = titleLabel?.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private lazy var imageWith:NSLayoutConstraint = newImageView.widthAnchor.constraint(equalToConstant: 15)
    
    private lazy var imagehegiht:NSLayoutConstraint = newImageView.widthAnchor.constraint(equalToConstant: 15)
    
    var imageSize:CGSize?{
        didSet {
            if let oldValue = oldValue {
                imageWith.constant = oldValue.width
                imagehegiht.constant = oldValue.height
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        
        addSubview(newImageView)
        newImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        newImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageWith.isActive = true
        imagehegiht.isActive = true
        
        addSubview(newTitLabel)
        newTitLabel.trailingAnchor.constraint(equalTo: newImageView.leadingAnchor, constant: -10).isActive = true
        newTitLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        newTitLabel.centerYAnchor.constraint(equalTo: newImageView.centerYAnchor).isActive = true
    }
    
    func setTitle(_ title: String?) {
        newTitLabel.text = title
        let attrString = NSMutableAttributedString(attributedString: newTitLabel.attributedText!)
        attrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "GenJyuuGothic-Medium", size: 14)!, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(3.0), range: NSRange(location: 0, length: attrString.length))
        newTitLabel.attributedText = attrString
    }
    
    func setImage(_ image: UIImage) {
        newImageView.image = image
    }
    
}
