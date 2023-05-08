//
//  CustomCalenderViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/8.
//

import UIKit

class CustomCalenderViewCell: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var weekLabel:UILabel!
    
    @IBOutlet weak var dateLabel:UILabel!
    
    var isCurrentDate:Bool = false {
        didSet{
            if
        }
    }

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
