//
//  AmountView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/16.
//

import UIKit

class AmountView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var storeName:UILabel!
    
    @IBOutlet weak var bottleCount:UILabel!
    
    @IBOutlet weak var batteryCount:UILabel!
    
    var mapInfo:MapInfo? {
        willSet{
            if let newValue = newValue {
                self.isHidden = false
                storeName.text = newValue.storeName
                bottleCount.text = "還可以投:\(newValue.remainingProcessable.bottle)瓶"
                batteryCount.text = "還可以投:\(newValue.remainingProcessable.battery)顆"
            }else{
                self.isHidden = true
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
    }
}
