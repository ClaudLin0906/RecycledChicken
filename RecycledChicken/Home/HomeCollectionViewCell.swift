//
//  HomeCollectionViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/2.
//

import UIKit
import Kingfisher
class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell(_ info:ADBannerInfo) {
        if let imageUrl = info.image, let url = URL(string: imageUrl) {
            imageView.kf.setImage(with: url)
        }
    }
    
}
