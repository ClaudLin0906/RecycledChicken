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
    
    @IBAction func closeAction(_ sender:UIButton) {
        self.isHidden = true
    }
    
    func setAmount(_ info:MapInfo) {
        stackView.removeFullyAllArrangedSubviews()
        self.isHidden = false
        storeName.text = info.name
        if let machineRemaining = info.machineRemaining {
            
            if let battery = machineRemaining.battery, battery > 0 {
                let label = labelInit("還可以投:\(battery)顆電池")
                stackView.addArrangedSubview(label)
            }
            
            if let bottle = machineRemaining.bottle, bottle > 0, let colorBottle = machineRemaining.colorBottle, colorBottle > 0 {
                let label = labelInit("還可以投無色:\(bottle)保特瓶")
                let colorLabel = labelInit("還可以投有色:\(bottle)保特瓶")
                stackView.addArrangedSubview(label)
                stackView.addArrangedSubview(colorLabel)
            } else {
                if let colorBottle = machineRemaining.colorBottle, colorBottle > 0 {
                    let label = labelInit("還可以投:\(colorBottle)保特瓶")
                    stackView.addArrangedSubview(label)
                }
                if let bottle = machineRemaining.bottle, bottle > 0 {
                    let label = labelInit("還可以投:\(bottle)保特瓶")
                    stackView.addArrangedSubview(label)
                }
            }
            
            if let can = machineRemaining.can, can > 0 {
                let label = labelInit("還可以投:\(can)鋁罐")
                stackView.addArrangedSubview(label)
            }
            
            if let cup = machineRemaining.cup, cup > 0 {
                let label = labelInit("還可以投:\(cup)紙杯")
                stackView.addArrangedSubview(label)
            }
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
