//
//  GuideOverlayView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2026/5/30.
//

import UIKit

class GuideOverlayView: UIView, NibOwnerLoadable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        loadNibContent()
        backgroundColor = .clear
    }
    
    /// 根據等級是否到達，決定是否顯示引導提示圖
    func setGuideImageView(isVisible: Bool) {
        isHidden = !isVisible
    }
    
}
