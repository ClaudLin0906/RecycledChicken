//
//  PointDetailView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2025/7/4.
//

import UIKit

class PointDetailView:  UIView, NibOwnerLoadable {
    
    @IBOutlet weak var pointsAboutToExpire: CustomLabel!
    
    @IBOutlet weak var expirationDate: CustomLabel!

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
    
    func set(_ expirePoint:String) {
        pointsAboutToExpire.text = expirePoint
        expirationDate.text = Calendar.current.endOfYear()
    }

}
