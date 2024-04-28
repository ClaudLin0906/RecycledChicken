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
    
    private var info:RecyceledSortInfo?
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()


    }
    
    func setRecycledRingInfo(_ info:RecyceledSortInfo, _ count:Double, _ total:Double) {
        self.info = info
        progressView.setCount(count, total, info.color, .white)
    }
}
