//
//  CustomTabbar.swift
//  RecycledChickenSwiftUI
//
//  Created by 林書郁 on 2024/1/10.
//

import SwiftUI

enum Tab: Int, CaseIterable {
    case point = 1
    case storeMap = 2
    case home = 3
    case task = 4
}

struct CustomTabbar: View {
    
    @Binding var selectedTab: Tab
    
    var body: some View {
       
        ZStack {
            Rectangle()
                .fill(Color(red: 175/255, green: 147/255, blue: 113/255))
                .frame(height: 70)
                .offset(y: 15)
            HStack(content: {
                TabBarIcon(selectedTab: $selectedTab, btnHandleTab: .point, title: "點數", noSelectedImageName: "fav-o", selectedImageName: "グループ 76")
                Spacer(minLength: 0)
                
                TabBarIcon(selectedTab: $selectedTab, btnHandleTab: .storeMap, title: "門市", noSelectedImageName: "location-o", selectedImageName: "グループ 77")
                Spacer(minLength: 0)
                
                TabBarIcon(selectedTab: $selectedTab, btnHandleTab: .home, title: "首頁", noSelectedImageName: "home", selectedImageName: "组 226")
                Spacer(minLength: 0)
                
                TabBarIcon(selectedTab: $selectedTab, btnHandleTab: .task, title: "任務", noSelectedImageName: "orderCopy", selectedImageName: "グループ 86")

            })
                .padding(.horizontal, 35)
                .offset(y: -10)
        }
    }
}

struct TabBarIcon: View {
    
    @Binding var selectedTab: Tab
    
    @State var btnHandleTab: Tab
    
    @State var title: String
    
    @State var noSelectedImageName: String
    
    @State var selectedImageName: String
    
    var body: some View {
        Button {
            selectedTab = btnHandleTab
        } label: {
            VStack( alignment: .center, spacing: 4) {
                Image(selectedTab == btnHandleTab ? noSelectedImageName: selectedImageName)
                    .resizable()
                    .scaleEffect(selectedTab == btnHandleTab ? 1.5 : 1)
                    .frame(width: 30 , height:30)
                Text(title)
                    .foregroundColor(.white)
                    .modifier(CustomFont())
            }
        }
    }
}

struct CustomTabbar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabbar(selectedTab: .constant(.home))
    }
}
