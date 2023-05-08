//
//  CustomCalenderView.swift
//  futures
//
//  Created by Claud on 2023/5/8.
//

import UIKit

class CustomCalenderView: UIView, NibOwnerLoadable {
        
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
            selectedDatesIndex = 0
        case "Monday":
            selectedDatesIndex = 1
        case "Tuesday":
            selectedDatesIndex = 2
        case "Wednesday":
            selectedDatesIndex = 3
        case "Thurday":
            selectedDatesIndex = 4
        case "Friday":
            selectedDatesIndex = 5
        case "Saturday":
            selectedDatesIndex = 6
        default:
            break
        }
        var sevenDaysToShow:[String] = []
        sevenDaysToShow.removeAll()
        for index in 0..<7 {
            let newIndex = index - selectedDatesIndex
            sevenDaysToShow.append(getDates(i: newIndex, currentDate: Date()).0)
        }
        
        let monthToSelectFrom = sevenDaysToShow[3]
        let dateFormatterMonth = DateFormatter()
        dateFormatterMonth.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterMonth.dateFormat = "dd-MM-yyyy"
        let monthDate = dateFormatterMonth.date(from: monthToSelectFrom)!
        
        let dateFormatterMonth1 = DateFormatter()
        dateFormatterMonth1.dateFormat = "MMMM, YYYY"
        let month = dateFormatterMonth1.string(from: monthDate)
        print("month \(month)")
        print("lastDateArr \(sevenDaysToShow.last)")
        print("firstDateArr \(sevenDaysToShow.first)")
        print("sevenDaysToShow \(sevenDaysToShow)")
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
 
