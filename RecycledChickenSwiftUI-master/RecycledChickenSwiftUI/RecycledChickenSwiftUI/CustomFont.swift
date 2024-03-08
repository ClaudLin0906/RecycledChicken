//
//  CustomFont.swift
//  RecycledChickenSwiftUI
//
//  Created by 林書郁 on 2024/1/2.
//

import Foundation
import SwiftUI

struct CustomFont: ViewModifier {
    
    @State var fontSize:CGFloat = 14
    
    func body ( content: Content) -> some View {
        content
            .kerning(4)
            .lineSpacing(5)
            .font(.custom("GenJyuuGothic-Normal", size: fontSize))
    }
    
}

struct CustomNumberFont: ViewModifier {
    
    @State var fontSize:CGFloat = 14
    
    func body ( content: Content) -> some View {
        content
            .kerning(4)
            .lineSpacing(5)
            .font(.custom("jf-openhuninn-2.0", size: fontSize))
    }
}
