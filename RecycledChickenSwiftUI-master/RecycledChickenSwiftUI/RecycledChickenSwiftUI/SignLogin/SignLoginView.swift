//
//  SignLoginView.swift
//  RecycledChickenSwiftUI
//
//  Created by 林書郁 on 2024/1/10.
//

import SwiftUI

struct SignLoginView: View {
    
    @State var isLoginPress: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("グループ 1089")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Image("グループ 971")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100,alignment: .topTrailing)
                    }
                    Spacer()
                        .frame(height: 10)
                    Text("「 這裡就是和我們泥滑島時空糾纏的世界嗎？ 」\n碳竹雞所居住的泥滑島正面臨著環境的危機\n希望你們可以一起減少排碳量\n而我們將幫助你們把廢棄物轉換成珍貴的資源！\n不只是為了泥滑島\n也為了保護你們美麗的星球，一同努力吧！").font(Font.custom("GenJyuuGothic-Normal", size: 14))
                        .lineSpacing(5)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: geometry.size.width * 0.9)
                    Button {
                        isLoginPress = true
                    } label: {
                        Text("會員登入")
                            .foregroundColor(.white)
                            .modifier(CustomFont())
                    }
                        .fullScreenCover(isPresented: $isLoginPress, content: LoginView.init)
                        .buttonStyle(CustomButtonStyle())
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 50)
                        .background(Color("defaultColor"))
                        .cornerRadius(25)
                        .frame(maxWidth: geometry.size.width * 0.6)
                    Button {
                        print("123")
                    } label: {
                        Text("會員註冊")
                            .modifier(CustomFont())
                    }
                        .buttonStyle(CustomButtonStyle())
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 50)
                        .background(.white)
                        .cornerRadius(25)
                        .frame(maxWidth: geometry.size.width * 0.6)
                    VStack(spacing: 1) {
                        Button {
                            print("123")
                        } label: {
                            Text("訪客登入")
                                .foregroundColor(.black)
                                .modifier(CustomFont())
                        }
                        Rectangle().frame(height: 1)
                    }
                        .frame(maxWidth: geometry.size.width * 0.2)
                    Spacer()
                    Image("footer")
                        .resizable()
                        .scaledToFit()
                }
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

struct SignLoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignLoginView()
    }
}
