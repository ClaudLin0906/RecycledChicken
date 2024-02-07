//
//  RecycledRingInfoView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/7.
//

import UIKit

class RecycledRingInfoView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var progressView:RingProgressSingleView!
    
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
        progressView.setCount(30, 50)
    }
}
