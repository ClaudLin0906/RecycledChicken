//
//  CarbonReductionItemCellView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/18.
//

import UIKit

class CarbonReductionItemCellView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var imageView:UIImageView!
    
    @IBOutlet weak var countLabel:UILabel!
        
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
    
    func setType(_ type:RecyceledSort) {
        imageView.image = UIImage(named: type.getInfo().iconName)
    }
    
    func setCount(_ count:Int) {
        countLabel.text = String(count)
    }

}
