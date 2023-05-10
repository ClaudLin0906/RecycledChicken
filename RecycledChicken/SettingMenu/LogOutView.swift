//
//  LogOutView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class LogOutView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var logOutBtn:UIButton!

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
    
    @IBAction func logOut(_ sender:UIButton){
        self.removeFromSuperview()
    }

}
