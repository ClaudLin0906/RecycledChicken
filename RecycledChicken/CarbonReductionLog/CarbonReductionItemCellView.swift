//
//  CarbonReductionItemCellView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/18.
//

import UIKit

protocol CarbonReductionItemCellViewDelegate {
    func tapItem(_ color:UIColor)
}

class CarbonReductionItemCellView: UIView, NibOwnerLoadable {
    
    var delegate:CarbonReductionItemCellViewDelegate?
    
    @IBOutlet weak var imageView:UIImageView!
    
    @IBOutlet weak var countLabel:UILabel!
    
    private var type:RecyceledSort?
    {
        willSet {
            if let newValue = newValue {
                imageView.image = UIImage(named: newValue.getInfo().iconName)
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
        loadNibContent()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func tapGesture(_ tap:UITapGestureRecognizer) {
        guard let type = type else { return }
        delegate?.tapItem(type.getInfo().color)
    }
    
    func setType(_ type:RecyceledSort) {
        self.type = type
    }
    
    func setCount(_ count:Int) {
        countLabel.text = String(count)
    }

}
