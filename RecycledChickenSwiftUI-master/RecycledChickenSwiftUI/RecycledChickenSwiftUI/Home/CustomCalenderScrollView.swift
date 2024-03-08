//
//  CustomCalenderScrollView.swift
//  RecycledChickenSwiftUI
//
//  Created by 林書郁 on 2024/1/16.
//

import SwiftUI

struct CustomCalenderScrollView: View {
    
    @State private var offSetX: CGFloat = 0
    
    @State private var selectedTab: Int = 0

    @State private var currentDate:Date = Date()
    
    @State private var lastWeekofDate:Date = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    
    @State private var twoWeekAgoOfDate:Date = Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()
//
    @State private var threeWeekAgoOfDate:Date = Calendar.current.date(byAdding: .day, value: -21, to: Date()) ?? Date()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                LazyHStack {
                    Group {
                        CustomCalenderView(date: currentDate)
                            .tag(0)
                        CustomCalenderView(date: lastWeekofDate)
                            .tag(1)
                        CustomCalenderView(date: twoWeekAgoOfDate)
                            .tag(2)
                        CustomCalenderView(date: threeWeekAgoOfDate)
                            .tag(3)
                    }
                        .frame(width: geometry.size.width)
                }
                .onChange(of:selectedTab) { newValue in
                    withAnimation {
                            offSetX = CGFloat(newValue) * geometry.size.width
                    }
                }
            }
                .disabled(true)
                .offset(x: offSetX)
                .gesture(DragGesture()
                    .onChanged(){ value in
                        print("滑動 \(value.translation.width)")
                    }
                    .onEnded{ value in
                        print("滑動結束 \(value.translation.width)")
                        if value.translation.width > 0 {
                            if selectedTab + 1 <= 3 {
                                selectedTab += 1
                            }
                        }
                        
                        if value.translation.width < 0 {
                            if selectedTab - 1 < 0 {
                                selectedTab -= 1
                            }
                        }
                    }
                )
        }
    }
    
    func getDateOfWeek(_ distanceDate:Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: distanceDate, to: Date()) ?? Date()
    }
}
