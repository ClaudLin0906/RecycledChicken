//
//  MallCollectionViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/5.
//

import UIKit
import Kingfisher
class MallCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView:UIImageView!
    
    @IBOutlet weak var titleLabel:CustomLabel!
    
    @IBOutlet weak var descriptionLabel:CustomLabel!
    
    func setCell(_ info:ItemInfo) {
        if let imageUrl = info.productImage, let url = URL(string: imageUrl) {
            imageView.kf.setImage(with: url)
        }
        titleLabel.text = info.productName
        descriptionLabel.text = info.description
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("imageView \(imageView.frame.height)")
    }
}
