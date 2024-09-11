//
//  RecycledRingInfoView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/7.
//

import UIKit

class RecycledRingInfoView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var progressView:RingProgressSingleView!
    
    @IBOutlet weak var ringProgressSingleBackgroundView:UIView!
    
    @IBOutlet weak var carbonReductionLabel:CustomLabel!
    
    @IBOutlet weak var recyclingLabel:CustomLabel!
    
    @IBOutlet weak var totalRecycledLabel:UILabel!
    
    @IBOutlet weak var convetValueLabel:UILabel!
    
    @IBOutlet weak var recycleUnitLabel:CustomLabel!
    
    @IBOutlet weak var oUnitLabel:CustomLabel!
            
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
        progressView.accessibilityLabel = NSLocalizedString("Move", comment: "")
        if getLanguage() == .english {
            if carbonReductionLabel != nil && recyclingLabel != nil {
                carbonReductionLabel.font = carbonReductionLabel.font.withSize(10)
                recyclingLabel.font = recyclingLabel.font.withSize(8)
            }
        }
        ringProgressSingleBackgroundView.layer.shadowOffset = CGSize(width: 1, height: 1)
        ringProgressSingleBackgroundView.layer.shadowOpacity = 0.2
    }

    func setRecycledRingInfo(_ totalRecycled:Int, _ recycleUnit:String, _ convetValue:String, _ oUnit:String, _ target:Double, _ startColor:UIColor , _ endColor:UIColor = .white) {
        totalRecycledLabel.text = String(totalRecycled)
        recycleUnitLabel.text = recycleUnit
        convetValueLabel.text = convetValue
        oUnitLabel.text = oUnit
        progressView.setCount(Double(totalRecycled), target, startColor, endColor)
    }
    
}
