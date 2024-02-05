//
//  MallCollectionViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/5.
//

import UIKit

class MallCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView:UIImageView!
    
    @IBOutlet weak var titleLabel:UILabel!
    
    func setCell(_ image:UIImage, title:String) {
        imageView.image = image
        titleLabel.text = title
    }
}
