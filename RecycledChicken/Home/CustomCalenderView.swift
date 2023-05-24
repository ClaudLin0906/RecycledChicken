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
    
    func getSevenDays(targetDate:Date){
        let weekDay = getDayOfTheWeek()
        var selectedDatesIndex = 0
        switch weekDay {
        case "Sun":
            selectedDatesIndex = 6
        case "Mon":
            selectedDatesIndex = 0
        case "Tue":
            selectedDatesIndex = 1
        case "Wed":
            selectedDatesIndex = 2
        case "Thu":
            selectedDatesIndex = 3
        case "Fri":
            selectedDatesIndex = 4
        case "Sat":
            selectedDatesIndex = 5
        default:
            break
        }
        var sevenDaysToShow:[(String, String, Date)] = []
        sevenDaysToShow.removeAll()
        for index in 0..<7 {
            let newIndex = index - selectedDatesIndex
//            sevenDaysToShow.append(getDates(i: newIndex, currentDate: Calendar.current.date(byAdding: .day, value: -7, to: Date())!))
            sevenDaysToShow.append(getDates(i: newIndex, currentDate: targetDate))
        }
        setCustomCalenderViewCell(monCalender, dataInfo: sevenDaysToShow[0])
        setCustomCalenderViewCell(tueCalender, dataInfo: sevenDaysToShow[1])
        setCustomCalenderViewCell(wedCalender, dataInfo: sevenDaysToShow[2])
        setCustomCalenderViewCell(thuCalender, dataInfo: sevenDaysToShow[3])
        setCustomCalenderViewCell(friCalender, dataInfo: sevenDaysToShow[4])
        setCustomCalenderViewCell(satCalender, dataInfo: sevenDaysToShow[5])
        setCustomCalenderViewCell(sunCalender, dataInfo: sevenDaysToShow[6])
    }

}

