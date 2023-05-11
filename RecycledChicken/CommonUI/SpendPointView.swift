//
//  SpendPointView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

class SpendPointView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var confirm:UIButton!

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
    
    func setConfirmBtnTitle(_ title:String){
        confirm.setTitle(title, for: .normal)
    }

}
