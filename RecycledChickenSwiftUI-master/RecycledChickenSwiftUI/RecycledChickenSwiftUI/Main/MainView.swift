//
//  MainView.swift
//  RecycledChickenSwiftUI
//
//  Created by 林書郁 on 2024/1/10.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentPage: Tab = .home
}

struct MainView: View {
    
    @StateObject private var viewRouter = ViewRouter()
        
    @State private var selection = 3
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        tabBarAppearance.backgroundColor = UIColor(red: 175/255, green: 147/255, blue: 113/255, alpha: 1)
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().unselectedItemTintColor = .white
    }
    
    var body: some View {
        
        TabView(selection: $selection, content: {
            PointView()
                .tabItem {
                    TabItemImage(name: Tab.point.rawValue == selection ? "fav-o": "グループ 76", isSelected: Tab.point.rawValue == selection)
                    Text("點數")
                }
                    .tag(1)
            StoreMapView()
                .tabItem {
                    TabItemImage(name: Tab.storeMap.rawValue == selection ? "location-o": "グループ 77", isSelected: Tab.storeMap.rawValue == selection)
                    Text("門市")
                }
                    .tag(2)

            HomeView()
                .tabItem {
                    TabItemImage(name: Tab.home.rawValue == selection ? "home": "组 226", isSelected: Tab.home.rawValue  == selection )
                    Text("首頁")
                }
                    .tag(3)

            TaskView()
                .tabItem {
                    TabItemImage(name: Tab.task.rawValue == selection ? "orderCopy": "グループ 86", isSelected: Tab.task.rawValue  == selection )
                    Text("任務")
                }
                .tag(4)
        })
        
    }
    
    func selectedCurrentPage() -> Tab {
        switch selection {
        case 1:
            return .point
        case 2:
            return .storeMap
        case 4:
            return .task
        default:
            return .home
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct TabItemImage: View {
    let name: String
    private let selectedSize = 45
    private let noSelectedSize = 30
    let isSelected: Bool
    var body: Image {
        let size = isSelected ? selectedSize: noSelectedSize
        let uiImage = resizedImage(named: self.name, for: CGSize(width:size , height: size)) ?? UIImage()
        return Image(uiImage: uiImage.withRenderingMode(.alwaysOriginal))
    }
    
    func resizedImage(named: String, for size: CGSize) -> UIImage? {
        guard let image = UIImage(named: named) else {
            return nil
        }

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
