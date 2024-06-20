//
//  ADBannerCollectionViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/1/31.
//

import UIKit
import Kingfisher
class ADBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        // Initialization code
    }
    
    func setCell(_ info:ADBannerInfo) {
        if let imageUrl = info.image, let url = URL(string: imageUrl) {
            imageView.kf.setImage(with: url)
        }
    }
    
    func setCell(_ imageURL:String) {
        if let url = URL(string: imageURL) {
            imageView.kf.setImage(with: url)
        }
    }

}
