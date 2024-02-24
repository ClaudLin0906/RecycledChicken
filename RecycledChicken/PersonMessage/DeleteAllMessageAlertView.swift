//
//  DeleteAllMessageAlertView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/24.
//

import UIKit

protocol DeleteAllMessageAlertViewDelegate {
    func deleteAllMessage()
}

class DeleteAllMessageAlertView: UIView, NibOwnerLoadable {
    
    var delegate:DeleteAllMessageAlertViewDelegate?
    
    @IBOutlet weak var confirmBtn:CustomButton!
    
    @IBOutlet weak var cancelBtn:CustomButton!
    
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

    @IBAction func confirm(_ sender:CustomButton) {
        delegate?.deleteAllMessage()
    }
    
    @IBAction func cancel(_ sender:CustomButton) {
        removeFromSuperview()
    }
    
}
