//
//  SpecialTaskView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/3/8.
//

import UIKit

class SpecialTaskView: UIView, NibOwnerLoadable {
    
    var info:MapInfo?
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let info = info else { return }
        addressLabel.text = info.address
        taskDescriptionLabel.text = info.taskDescription
    }

    @IBAction func closeBtnHandle(_ sender:UIButton) {
        isHidden.toggle()
    }
    
}
