//
//  SpendPointAlertView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/13.
//

import UIKit

protocol SpendPointAlertViewDelegate{
    func confirm(_ sender:UIButton)
}

class SpendPointAlertView: UIView, NibOwnerLoadable {
    
    var delegate:SpendPointAlertViewDelegate?

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
    
    @IBAction func confirm(_ sender:UIButton) {
        self.removeFromSuperview()
        delegate?.confirm(sender)
    }
    
    @IBAction func cancel(_ sender:UIButton) {
        self.removeFromSuperview()
    }
}
