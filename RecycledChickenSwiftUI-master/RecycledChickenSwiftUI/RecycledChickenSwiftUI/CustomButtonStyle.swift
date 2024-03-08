//
//  CustomButtonStyle.swift
//  RecycledChickenSwiftUI
//
//  Created by 林書郁 on 2024/1/3.
//

import Foundation
import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration
            .label.modifier(CustomFont())
    }
    
}
