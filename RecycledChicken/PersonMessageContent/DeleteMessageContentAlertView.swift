//
//  DeleteMessageContentAlertView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/3/14.
//

import UIKit

protocol DeleteMessageContentAlertViewDelegate {
    func deleteMessage()
}

class DeleteMessageContentAlertView: UIView, NibOwnerLoadable {
    
    var delegate:DeleteMessageContentAlertViewDelegate?
    
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
        delegate?.deleteMessage()
    }
    
    @IBAction func cancel(_ sender:CustomButton) {
        removeFromSuperview()
    }

}
