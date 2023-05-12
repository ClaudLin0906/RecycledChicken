//
//  SearchView.swift
//  RecycledChicken
//
//  Created by Claud on 2023/5/12.
//

import UIKit

class SearchView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var textField:UITextField!
    
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

}
