//
//  MapIconView.swift
//  RecycledChicken
//
//  Created by sj on 2024/6/9.
//

import UIKit

class MapIconView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var stackView:UIStackView!
    
    @IBOutlet weak var backgroundImageView:UIImageView!

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
    }
    
    func addImageView(_ image:UIImage) {
        let imageView = UIImageView()
        imageView.image = image
        stackView.addArrangedSubview(imageView)
    }
    
    func setBackgroundImageView(_ image:UIImage) {
        backgroundImageView.image = image
    }
    
}
