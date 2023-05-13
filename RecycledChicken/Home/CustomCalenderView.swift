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
        monCalender.weekLabel.text = "mon"
        tueCalender.weekLabel.text = "tue"
        wedCalender.weekLabel.text = "wed"
        thuCalender.weekLabel.text = "thu"
        friCalender.weekLabel.text = "fri"
        satCalender.weekLabel.text = "sat"
        sunCalender.weekLabel.text = "sun"
        getSevenDays()
    }
    
    private func getSevenDays(){
        let weekDay = getDayOfTheWeek()
        var selectedDatesIndex = 0
        switch weekDay {
        case "Sunday":
            selectedDatesIndex = 6
            sunCalender.isCurrentDate = true
        case "Monday":
            selectedDatesIndex = 0
            monCalender.isCurrentDate = true
        case "Tuesday":
            selectedDatesIndex = 1
            tueCalender.isCurrentDate = true
        case "Wednesday":
            selectedDatesIndex = 2
            wedCalender.isCurrentDate = true
        case "Thurday":
            selectedDatesIndex = 3
            thuCalender.isCurrentDate = true
        case "Friday":
            selectedDatesIndex = 4
            friCalender.isCurrentDate = true
        case "Saturday":
            selectedDatesIndex = 5
            satCalender.isCurrentDate = true
        default:
            break
        }
        var sevenDaysToShow:[String] = []
        sevenDaysToShow.removeAll()
        for index in 0..<7 {
            let newIndex = index - selectedDatesIndex
            sevenDaysToShow.append(getDates(i: newIndex, currentDate: Date()).0)
        }
        
        for show in sevenDaysToShow {
            if show == getDates(i: 0, currentDate: Date()).0 {
                print(show)
            }
        }
        
        monCalender.dateLabel.text = String(sevenDaysToShow[0].split(separator: "-")[2])
        tueCalender.dateLabel.text = String(sevenDaysToShow[1].split(separator: "-")[2])
        wedCalender.dateLabel.text = String(sevenDaysToShow[2].split(separator: "-")[2])
        thuCalender.dateLabel.text = String(sevenDaysToShow[3].split(separator: "-")[2])
        friCalender.dateLabel.text = String(sevenDaysToShow[4].split(separator: "-")[2])
        satCalender.dateLabel.text = String(sevenDaysToShow[5].split(separator: "-")[2])
        sunCalender.dateLabel.text = String(sevenDaysToShow[6].split(separator: "-")[2])
        
    }

}

