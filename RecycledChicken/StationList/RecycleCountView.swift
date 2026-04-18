//
//  RecycleCountView.swift
//  RecycledChicken
//

import UIKit

class RecycleCountView: UIView, NibOwnerLoadable {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var countLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }

    func setValue(item: RecycleItem, count: Int) {
        iconImageView.image = UIImage(named: item.iconName)
        countLabel.text = "\(count)"
    }
    
}
