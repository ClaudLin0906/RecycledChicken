//
//  CustomCalenderView.swift
//  futures
//
//  Created by Claud on 2023/5/8.
//

import UIKit

class CustomCalenderView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var monCalender:CustomCalenderViewCell!
    
    @IBOutlet weak var tueCalender:CustomCalenderViewCell!
    
    @IBOutlet weak var wedCalender:CustomCalenderViewCell!
    
    @IBOutlet weak var thuCalender:CustomCalenderViewCell!
    
    @IBOutlet weak var friCalender:CustomCalenderViewCell!
    
    @IBOutlet weak var satCalender:CustomCalenderViewCell!
    
    @IBOutlet weak var sunCalender:CustomCalenderViewCell!
    
    lazy var week:[CustomCalenderViewCell] = [ monCalender, tueCalender, wedCalender, thuCalender, friCalender, satCalender, sunCalender ]
        
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
    
    private func setCustomCalenderViewCell(_ calenderViewCell:CustomCalenderViewCell,dataInfo:(String, String, Date)){
        calenderViewCell.dateID = dataInfo.0
        calenderViewCell.dateLabel.text = String(dataInfo.0.split(separator: "-")[2])
        calenderViewCell.weekLabel.text = dataInfo.1
    }
    
    func checkIsSelected(){
        for day in week {
            day.checkIsSelected()
        }
        updateHomeDate()
    }
    
    private func updateHomeDate() {
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let homeVC = parentResponder as? HomeVC {
                homeVC.updateCurrentDateInfo()
            }
            parentResponder = parentResponder?.next
        }
    }
    
    func getSevenDays(targetDate:Date) {
        let sevenDaysToShow = getSevenDaysArray(targetDate: targetDate)
        setCustomCalenderViewCell(monCalender, dataInfo: sevenDaysToShow[0])
        setCustomCalenderViewCell(tueCalender, dataInfo: sevenDaysToShow[1])
        setCustomCalenderViewCell(wedCalender, dataInfo: sevenDaysToShow[2])
        setCustomCalenderViewCell(thuCalender, dataInfo: sevenDaysToShow[3])
        setCustomCalenderViewCell(friCalender, dataInfo: sevenDaysToShow[4])
        setCustomCalenderViewCell(satCalender, dataInfo: sevenDaysToShow[5])
        setCustomCalenderViewCell(sunCalender, dataInfo: sevenDaysToShow[6])
    }

}

