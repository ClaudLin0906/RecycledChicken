//
//  RecycledLevelView.swift
//  RecycledChickenSwiftUI
//
//  Created by 林書郁 on 2024/1/15.
//

import SwiftUI

struct RecycledLevelView: View {
    
    @State var currentData = "2024/01/15"
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 226/255, green: 194/255, blue: 125/255))
            HStack(spacing: 5) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("碳竹雞養成")
                        .modifier(CustomFont(fontSize: 14))
                        .foregroundColor(.white)
                        .frame(width: 95, height: 20)
                    Text(currentData)
                        .modifier(CustomFont(fontSize: 10))
                        .foregroundColor(.white)
                        .frame(width: 95, height: 20)
                    Spacer()
                    Image("level1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        
                }
                    .frame(width: 100)
                    .padding(10)
                Image("RecycledLevel1")
                    .resizable()
                
            }
        }
    }
    
}

struct RecycledLevelView_Previews: PreviewProvider {
    static var previews: some View {
        RecycledLevelView()
    }
}
