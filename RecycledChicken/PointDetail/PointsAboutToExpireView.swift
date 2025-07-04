//
//  PointsAboutToExpireView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2025/7/4.
//

import UIKit

class PointsAboutToExpireView: UIView, NibOwnerLoadable {

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
