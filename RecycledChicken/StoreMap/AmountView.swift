//
//  AmountView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/16.
//

import UIKit

class AmountView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var storeName:UILabel!
    
    @IBOutlet weak var stackView:UIStackView!
    
    var mapInfo:MapInfo?

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
    
    func setAmount(_ info:MapInfo) {
        self.isHidden = false
        storeName.text = info.storeName

        if let battery = info.remainingProcessable.battery, battery > 0 {
            let label = labelInit("還可以投:\(battery)顆")
            stackView.addArrangedSubview(label)
        }
        if let bottle = info.remainingProcessable.bottle, bottle > 0 {
            let label = labelInit("還可以投:\(bottle)瓶")
            stackView.addArrangedSubview(label)
        }
    }
    
    private func labelInit(_ textCount:String) -> UILabel {
        let label = UILabel()
        label.font = storeName.font
        label.text = textCount
        label.textColor = storeName.textColor
        label.textAlignment = storeName.textAlignment
        return label
    }
}
