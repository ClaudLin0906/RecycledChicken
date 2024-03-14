//
//  UpdateAppAlertView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/3/14.
//

import UIKit

class UpdateAppAlertView: UIView, NibOwnerLoadable {

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
    
    @IBAction func openAppleStore(_ sender:UIButton) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id6449214570") {
            UIApplication.shared.open(url)
        }
    }
}
