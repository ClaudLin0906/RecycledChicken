//
//  PointsAboutToExpireView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2025/7/4.
//

import UIKit

class PointsAboutToExpireView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var titleLabel: CustomLabel!
    
    @IBOutlet weak var expirationDateLabel: CustomLabel!
    
    @IBOutlet weak var pointLabel: UILabel!

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
    
    func set(_ title: String, _ offset:Int = 0, point:String = "0" ) {
        titleLabel.text = title
        expirationDateLabel.text = "到期日 " + Calendar.current.endOfYear(offset: offset)
        pointLabel.text = point
    }
}
