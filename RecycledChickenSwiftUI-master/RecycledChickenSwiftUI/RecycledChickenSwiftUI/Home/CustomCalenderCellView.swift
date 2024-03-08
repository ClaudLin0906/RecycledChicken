//
//  CustomCalenderCellView.swift
//  RecycledChickenSwiftUI
//
//  Created by 林書郁 on 2024/1/16.
//

import SwiftUI

struct CustomCalenderCellView: View {
    
    @Binding var date:Date
    
    @State var index:Int
    
    @State var isSelected = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(isSelected ? Color(hex: "E2C27D") : .clear)
                .cornerRadius(10)
                .shadow(radius: isSelected ? 2 : 0, x: isSelected ? 1 : 0, y: isSelected ? 1 : 0)
            VStack(spacing:0) {
                Group {
                    Text(getSevenDays().1)
                        .modifier(CustomFont(fontSize: 12))
                        .frame(height: 20)
                    Text(getSevenDays().0.split(separator: "-")[2])
                        .modifier(CustomFont(fontSize: 25))
                        .frame(maxHeight: .infinity)
                }
                    .foregroundColor(isSelected ? .white : .black)
            }
        }

    }
    
    private func getSevenDays() -> (String, String, Date) {
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
            sevenDaysToShow.append(getDates(i: newIndex, currentDate: date))
        }
        return sevenDaysToShow[index]
    }
}

//struct CustomCalenderCellView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        CustomCalenderCellView()
//    }
//}
