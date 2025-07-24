//
//  AuthView.swift
//  iosTest
//
//  Created by Александра Згонникова on 24.07.2025.
//

import SwiftUI

struct AuthView: View {
    
    @StateObject var viewModel = AuthViewModel()
    
    @FocusState private var isloginFocused: Bool
    @FocusState private var isPasswordFocused: Bool 
    
    @State var isVisible: Bool = false
    @State private var isToastVisible = false
    
    
    @State private var showAppFlow: Bool = false
    
    var body: some View {
        NavigationStack {
            login
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showAppFlow) {
            NavigationBottomBar()
        }

    }
}

#Preview {
    AuthView()
}

extension AuthView {
    private var login: some View {
        VStack {
            Spacer()
            
            Image("logo")
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 103)
                .foregroundStyle(Color.theme.accentColor)
                .padding()
            
            ZStack(alignment: .leading) {
                TextField(text: $viewModel.login) {
                    Text(NSLocalizedString("login", comment: ""))
                        .font(.custom("SF UI Display", size: 13))
                        .fontWeight(.regular)
                        .foregroundStyle(Color.theme.colorForBorders)
                }
                .font(.custom("SF UI Display", size: 13))
                .fontWeight(.regular)
                .foregroundStyle(Color.theme.colorForInputText)
                .focused($isloginFocused)
                .textFieldStyle(.plain)
                .disableAutocorrection(true)
                .padding(.horizontal, 38)
                .padding(.vertical, 12)
                .keyboardType(.emailAddress)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.theme.colorWhite)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.theme.colorForBorders, lineWidth: 1)
                )
                .overlay(
                    Image("loginIcon")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color.theme.colorForBorders)
                        .padding(.leading, 12),
                    alignment: .leading
                )
            }
            .frame(height: 50)
            .padding(.horizontal)
            
            ZStack(alignment: .leading) {
                Group {
                    if isVisible {
                        TextField(text: $viewModel.password) {
                            Text(NSLocalizedString("password", comment: ""))
                                .font(.custom("SF UI Display", size: 13))
                                .fontWeight(.regular)
                                .foregroundStyle(Color.theme.colorForBorders)
                        }
                        .font(.custom("SF UI Display", size: 13))
                        .fontWeight(.regular)
                        .foregroundStyle(Color.theme.colorForInputText)
                    } else {
                        SecureField(text: $viewModel.password) {
                            Text(NSLocalizedString("password", comment: ""))
                                .font(.custom("SF UI Display", size: 13))
                                .fontWeight(.regular)
                                .foregroundStyle(Color.theme.colorForBorders)
                        }
                        .font(.custom("SF UI Display", size: 13))
                        .fontWeight(.regular)
                        .foregroundStyle(Color.theme.colorForInputText)
                    }
                }
                .focused($isPasswordFocused)
                .textFieldStyle(.plain)
                .padding(.horizontal, 38)
                .padding(.vertical, 12)
                .disableAutocorrection(true)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.theme.colorWhite)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.theme.colorForBorders, lineWidth: 1)
                )
                .overlay (
                    Image("passwordIcon")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color.theme.colorForBorders)
                        .padding(.leading, 12),
                    alignment: .leading
                )
                .overlay (
                    Image(isVisible ? "inVisable" : "isVisable")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color.theme.colorForBorders)
                        .padding(.trailing, 12)
                        .opacity(viewModel.password.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            isVisible.toggle()
                        },
                    alignment: .trailing
                )
            }
            .frame(height: 50)
            .padding(.horizontal)
            
            Spacer()
            
            VStack {
                Button(action: {
                    UIApplication.shared.endEditing()
                    viewModel.logIn { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                print("Success")
                                showAppFlow = true
                                viewModel.isSuccessToastBarVisible = true
                            case .failure(let error):
                                isToastVisible = true
                            }
                        }
                    }
                }, label: {
                    Text(NSLocalizedString("login", comment: ""))
                        .font(.custom("SF UI Display", size: 16))
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .foregroundStyle(
                            (!viewModel.login.isEmpty && !viewModel.password.isEmpty)
                            ? Color.theme.colorWhite
                            : Color.theme.colorWhite.opacity(0.6)
                        )
                        .background(
                            (!viewModel.login.isEmpty && !viewModel.password.isEmpty)
                            ? Color.theme.accentColor
                            : Color.theme.accentColor.opacity(0.4)
                        )
                        .cornerRadius(20)
                })
                .contentShape(Rectangle())
                .buttonStyle(ScaledButtonStyle())
                .disabled(viewModel.login.isEmpty || viewModel.password.isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: 118)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.theme.colorWhite)
                    .mask(
                        VStack(spacing: 0) {
                            Rectangle()
                        }
                    )
                    .ignoresSafeArea()
            )
            
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .frame(maxWidth: .infinity)
        .background(Color.theme.background)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(NSLocalizedString("auth", comment: ""))
                    .font(.custom("SF UI Display", size: 16))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.theme.colorBlack)
            }
        }
        .showToast(
            message: NSLocalizedString("wrongCreds", comment: ""),
            color: Color.theme.colorWhite,
            textColor: Color.theme.accentColor,
            image: "cancleCircle",
            isVisible: $isToastVisible
        )
    }
}
