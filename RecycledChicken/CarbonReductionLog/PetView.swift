//
//  PetView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/8.
//

import UIKit

class PetView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var petAmount:UILabel!

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
        print(petAmount.font)
    }

}
