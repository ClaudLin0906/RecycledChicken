//
//  CustomCalenderView.swift
//  RecycledChickenSwiftUI
//
//  Created by 林書郁 on 2024/1/16.
//

import SwiftUI

struct CustomCalenderView: View {
    
//    @Binding private var date: Date
    
    @State var date:Date
    
    var body: some View {
        HStack(spacing: 5) {
            Group {
                CustomCalenderCellView(date: $date, index: 0)
                CustomCalenderCellView(date: $date, index: 1)
                CustomCalenderCellView(date: $date, index: 2)
                CustomCalenderCellView(date: $date, index: 3)
                CustomCalenderCellView(date: $date, index: 4)
                CustomCalenderCellView(date: $date, index: 5)
                CustomCalenderCellView(date: $date, index: 6)
            }
            .frame(maxWidth: .infinity)
        }
    }
}


