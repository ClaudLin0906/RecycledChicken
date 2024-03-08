//
//  LoginView.swift
//  RecycledChickenSwiftUI
//
//  Created by 林書郁 on 2024/1/8.
//

import SwiftUI

struct LoginView: View {
        
    @State private var phoneNumber = ""
    
    @State private var password = ""
    
    @State private var showAlert = false
    
    @State private var alertMsg = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("グループ 1089")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Spacer()
                        Image("グループ 971")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100,alignment: .topTrailing)
                    }
                    Spacer()
                    Image("グループ 1090")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.9, height: 350)
                        .overlay {
                            VStack {
                                Text("Login")
                                .modifier(CustomFont())
                                TextFieldView(text: $phoneNumber, title: "手機")
                                PasswordTextFieldView(text: $password, title: "密碼")
                            }.frame(width: geometry.size.width * 0.55)
                        }
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Button {
                            login()
                        } label: {
                            Text("登入")
                        }
                            .frame(width: 100, height: 40)
                            .background(Color(red: 211/255, green: 176/255, blue: 106/255))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .buttonStyle(CustomButtonStyle())
                        Button {
                        } label: {
                            Text("回首頁")
                        }
                            .frame(width: 100, height: 40)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(20)
                            .buttonStyle(CustomButtonStyle())
                            .alert(alertMsg, isPresented: $showAlert) {
                                Button {
                                    
                                } label: {
                                    Text("OK").modifier(CustomFont())
                                }
                            }
                    }
                    Spacer()
                    Image("footer")
                        .resizable()
                        .scaledToFit()
                }.ignoresSafeArea(edges: .bottom)
            }
        }
    }
    
    func login() {
        alertMsg = ""
        if phoneNumber == "" {
            alertMsg += "電話不能為空"
        } else if !validateCellPhone(text: phoneNumber) {
            alertMsg += "電話格式不對"
        }
        if password == "" {
            alertMsg += "密碼不能為空"
        }
        guard alertMsg == "" else {
            showAlert = true
            return
        }
        let loginInfo = AccountInfo(userPhoneNumber: phoneNumber, userPassword: password)
        let loginInfoDic = try? loginInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.login, parameters: loginInfoDic) { data, statusCode, errorMSG in
            guard statusCode == 200 else {
                alertMsg = "帳號密碼有誤"
                showAlert = true
                return
            }
            
            if let data = data {
                let json = NetworkManager.shared.dataToDictionary(data: data)
                if let token = json["token"] as? String {
                    print(token)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    
    static var previews: some View {
        LoginView()
    }
    
}

struct TextFieldView: View {
    @Binding var text: String
    var title: String
    
    init(text: Binding<String>, title: String) {
        self._text = text
        self.title = title
    }
    
    var body: some View {
        Group {
            VStack(spacing: 5, content: {
                HStack {
                    Text(title).modifier(CustomFont())
                    TextField("", text: $text)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.black)
                }
                Rectangle()
                    .fill(Color(red: 175/255, green: 147/255, blue: 113/255))
                    .frame(height: 1)
            })
        }
    }
}


struct PasswordTextFieldView: View {
    
    @Binding var text: String
    
    @State var showPassword: Bool = true
    
    var title: String
    
    init(text: Binding<String>, title: String) {
        self._text = text
        self.title = title
    }
    
    var body: some View {
        Group {
            VStack(spacing: 5, content: {
                HStack {
                    Text(title).modifier(CustomFont())
                    Group {
                        if showPassword {
                            TextField("", text: $text)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.black)
                        } else {
                            SecureField("", text: $text)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.black)
                        }
                    }
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: self.showPassword ? "eye.slash" : "eye")
                            .tint(Color(red: 112/255, green: 112/255, blue: 112/255))
                    }
                }
                Rectangle()
                    .fill(Color(red: 175/255, green: 147/255, blue: 113/255))
                    .frame(height: 1)
            })
        }
    }
}

