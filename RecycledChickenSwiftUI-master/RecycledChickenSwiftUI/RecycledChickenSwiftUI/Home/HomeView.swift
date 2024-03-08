//
//  HomeView.swift
//  RecycledChickenSwiftUI
//
//  Created by 林書郁 on 2024/1/11.
//

import SwiftUI

struct HomeView: View {
    
    @State private var botCount:Int = 0
    
    @State private var batCount:Int = 0
    
    @State private var gestureOffset: CGFloat = 0.0
    
    @State private var offSetX:CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color(red: 70/255, green: 96/255, blue: 85/255))
                .ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    Text("good")
                        .modifier(CustomFont(fontSize: 17))
                        .lineLimit(0)
                        .foregroundColor(.white)
                    HStack(spacing: 20) {
                        
                        Button {
                        } label: {
                            HomeButtonView(imageName: "ehYnxi", buttonTitle: "帳戶")
                        }
                        
                        Button {
                        } label: {
                            HomeButtonView(imageName: "fZyCL6", buttonTitle: "訊息")
                        }
                        
                        Spacer()
                        
                        Button {
                        } label: {
                            HomeButtonView(imageName: "y7CRSB", buttonTitle: "設定")
                        }
                    }
                }
                    .padding(.horizontal, 40)
                ZStack {
                    Rectangle()
                        .fill(Color(red: 239/255, green: 233/255, blue: 208/255))
                        .frame(height: geometry.size.height)
                        .cornerRadius(60)
                    VStack {
                        Spacer()
                            .frame(height: 30)
                            .background(.clear)
                        ScrollView {
                            VStack(spacing: 20) {
                                BarCodeView(phoneNumber: "0932266860")
                                    .frame(height: 150)
                                    .padding(.horizontal, 10)
                                Spacer()
                                Button {
                                } label: {
                                    Text("減碳歷程")
                                        .foregroundColor(.black)
                                        .modifier(CustomFont())
                                        .background(RoundedRectangle(cornerRadius: 20).fill(.white).frame(width: 150, height: 40))
                                        
                                }
                                    .shadow(radius: 4, x: 1, y: 1)
                                Spacer()
                                RecycledLevelView()
                                    .padding(.horizontal, 10)
                                    .frame(height: 200)
                                    .cornerRadius(30)
                                    .shadow(radius: 4, x: 1, y: 1)
                                Spacer()
                                HStack(spacing: 10) {
                                    Text("當日養分")
                                        .modifier(CustomFont())
                                    Group {
                                        DisplayView(imageName: "gUkPAm.tif", count: $botCount)
                                        DisplayView(imageName: "グループ 52", count: $batCount)
                                    }
                                        .frame(width: 40, height: 30)
                                }
                                Spacer()
                                CustomCalenderScrollView()
                                    .frame(height: 70)
                                Spacer(minLength:100)
                            }
                                .padding(20)
                        }
                    }
                }
            }
        }
    }
}

struct BarCodeView: View {
    
    @State var phoneNumber:String = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .cornerRadius(30)
                .shadow(radius: 4, x: 1, y: 1)
            VStack(spacing: 5){
                Spacer()
                Text("會員條碼").modifier(CustomFont(fontSize: 17))
                    .frame(height: 30)
                Image(uiImage: UIImage(data: barcodeData(str: phoneNumber))!)
                    .resizable()
                Text(phoneNumber).modifier(CustomFont(fontSize: 17))
                    .frame(height: 30)
                Spacer()
            }
        }
    }
    
    func barcodeData(str: String) -> Data {
        let data = str.data(using: .ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let image = filter?.outputImage!
        let uiimage = UIImage(ciImage: image!)
        return uiimage.pngData()!
    }
}

struct DisplayView: View {
    
    @State var imageName:String
    
    @Binding var count:Int
    
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .tint(.black)
            Text(String(count))
                .foregroundColor(Color(hex: "AF9371"))
                .modifier(CustomNumberFont(fontSize: 20))
        }
    }
}

struct HomeButtonView: View {
    
    @State var imageName: String
    
    @State var buttonTitle: String
    
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 20 , height:20)
            Text(buttonTitle)
                .modifier(CustomFont(fontSize: 17))
                .foregroundColor(.white)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
    }
}

 
