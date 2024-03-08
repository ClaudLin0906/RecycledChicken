//
//  RecycledChickenSwiftUIApp.swift
//  RecycledChickenSwiftUI
//
//  Created by 林書郁 on 2024/1/2.
//

import SwiftUI

@main
struct RecycledChickenSwiftUIApp: App {
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
//            ContentView()
            MainView()
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background:
                print("App State : Background")
            case .inactive:
                print("App State : Inactive")
            case .active:
                print("App State : Active")
            @unknown default:
                print("App State : Unknown")
            }
        }
    }
}
