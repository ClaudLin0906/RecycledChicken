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
                let label = labelInit("電池還可投入：\(battery)")
                stackView.addArrangedSubview(label)
            }
            
            if let bottle = machineRemaining.bottle, bottle > 0 {
                let label = labelInit("寶特瓶還可投入：\(bottle)")
                stackView.addArrangedSubview(label)
            }
            
            if let coloredBottle = machineRemaining.coloredBottle, coloredBottle > 0 {
                let label = labelInit("有色寶特瓶還可投入：\(coloredBottle)")
                stackView.addArrangedSubview(label)
            }
            
            if let colorlessBottle = machineRemaining.colorlessBottle, colorlessBottle > 0 {
                let label = labelInit("透明寶特瓶還可投入：\(colorlessBottle)")
                stackView.addArrangedSubview(label)
            }
            
            if let can = machineRemaining.can, can > 0 {
                let label = labelInit("鋁罐還可投入\(can)")
                stackView.addArrangedSubview(label)
            }
            
            if let cup = machineRemaining.cup, cup > 0 {
                let label = labelInit("紙杯還可投入:\(cup)")
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
