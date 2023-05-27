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
        
    var dateID:String?{
        didSet{
            checkIsSelected()
        }
    }
    
    var isCurrentDate:Bool = false {
        willSet{
            if newValue {
                backgroundColor = CommonColor.shared.color9
                weekLabel.textColor = .white
                dateLabel.textColor = .white
                self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
                self.layer.shadowOpacity = 0.6
            } else {
                backgroundColor = .clear
                weekLabel.textColor = .black
                dateLabel.textColor = .black
                self.layer.shadowOffset = .zero
                self.layer.shadowOpacity = 0
            }
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
    
    func checkIsSelected(){
        if let dateID = dateID  {
            if dateID == CustomCalenderModel.shared.selectedDate {
                isCurrentDate = true
            }else{
                isCurrentDate = false
            }
        }else{
            print("dateID is nil")
        }
    }

    private func customInit(){
        loadNibContent()
    }
    
    @IBAction func btnAction(_ sender:UIButton) {
        if let dateID = dateID {
            CustomCalenderModel.shared.selectedDate = dateID
            if let customCalenderView = self.superview?.superview?.superview as? CustomCalenderView {
                customCalenderView.checkIsSelected()
            }
        }
    }

}
