//
//  DeleteAccountAlertView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/15.
//

import UIKit

class DeleteAccountAlertView: UIView, NibOwnerLoadable {

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
    
    @IBAction func cancel(_ sender:UIButton) {
        self.removeFromSuperview()
    }

}
