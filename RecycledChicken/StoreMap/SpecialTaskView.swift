//
//  SpecialTaskView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/3/8.
//

import UIKit

protocol SpecialTaskViewDelegate {
    func tapClose()
}

class SpecialTaskView: UIView, NibOwnerLoadable {
    
    var info:MapInfo?
    
    var delegate:SpecialTaskViewDelegate?
    
    @IBOutlet weak var addressLabel:UILabel!
    
    @IBOutlet weak var taskDescriptionLabel:UILabel!

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
    
    func setInfo() {
        guard let info = info else { return }
        addressLabel.text = info.address
        taskDescriptionLabel.text = info.description
    }

    @IBAction func closeBtnHandle(_ sender:UIButton) {
        delegate?.tapClose()
        isHidden.toggle()
    }
    
}
