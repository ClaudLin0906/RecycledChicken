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
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "EEEE"
        let weekDay = dateFormatter1.string(from: Date())
        var selectedDatesIndex = 0
        switch weekDay {
        case "Sunday":
            selectedDatesIndex = 6
        case "Monday":
            selectedDatesIndex = 0
        case "Tuesday":
            selectedDatesIndex = 1
        case "Wednesday":
            selectedDatesIndex = 2
        case "Thurday":
            selectedDatesIndex = 3
        case "Friday":
            selectedDatesIndex = 4
        case "Saturday":
            selectedDatesIndex = 5
        default:
            break
        }
        var sevenDaysToShow:[String] = []
        sevenDaysToShow.removeAll()
        for index in 0..<7 {
            let newIndex = index - selectedDatesIndex
            sevenDaysToShow.append(getDates(i: newIndex, currentDate: Date()).0)
        }
        
        let dateFormatterMonth = DateFormatter()
        dateFormatterMonth.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterMonth.dateFormat = "dd-MM-yyyy"
        
        monCalender.dateLabel.text = String(sevenDaysToShow[0].split(separator: "-")[0])
        tueCalender.dateLabel.text = String(sevenDaysToShow[1].split(separator: "-")[0])
        wedCalender.dateLabel.text = String(sevenDaysToShow[2].split(separator: "-")[0])
        thuCalender.dateLabel.text = String(sevenDaysToShow[3].split(separator: "-")[0])
        friCalender.dateLabel.text = String(sevenDaysToShow[4].split(separator: "-")[0])
        satCalender.dateLabel.text = String(sevenDaysToShow[5].split(separator: "-")[0])
        sunCalender.dateLabel.text = String(sevenDaysToShow[6].split(separator: "-")[0])
        
    }
    
    private func getDates(i: Int, currentDate:Date) -> (String, String){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        var date = currentDate
        let cal = Calendar.current
        date = cal.date(byAdding: .day, value: i, to: date)!
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let stringFormate1 = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let stringFormate2 = dateFormatter.string(from: date)
        return (stringFormate1, stringFormate2)
    }
}

//extension CustomCalenderView:UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        7
//    }
//
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
//
//
//}
 
