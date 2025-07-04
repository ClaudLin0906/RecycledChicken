//
//  PointDetailAlertCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2025/7/4.
//

import UIKit

class PointDetailAlertCell: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var titleLabel: CustomLabel!
    
    @IBOutlet weak var alertTextView:UITextView!

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
    
    func setCell(_ title:String, _ content:String) {
        titleLabel.text = title
        alertTextView.text = content
    }

}
