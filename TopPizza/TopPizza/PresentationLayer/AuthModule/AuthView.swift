//
//  AuthView.swift
//  TopPizza
//
//  Created by Константин Клинов on 24/07/25.
//

import SwiftUI

struct AuthView: View {

    @State private var username = ""
    @State private var password = ""
    @State private var isSignUpMode = false
    @State private var isLoggedIn = false
    @State private var errorMessage: String?
    @State private var isPasswordVisible = false
    @State private var showBanner = false
    @State private var bannerType: BannerType = .error

    @StateObject private var keyboard = KeyboardResponder()

    private let presenter: AuthPresenterProtocol
    
    init(presenter: AuthPresenterProtocol = AuthPresenter()) {
        self.presenter = presenter
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color(Constants.Colors.mainBackground)
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    VStack(spacing: 20) {
                        Image("ic_logo_purple")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 322, height: 101)

                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                            ZStack(alignment: .leading) {
                                if username.isEmpty {
                                    Text("Username")
                                        .foregroundColor(Color(Constants.Colors.borderColor))
                                }
                                TextField("", text: $username)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(Constants.Colors.borderColor), lineWidth: 1)
                        )
                        .padding(.horizontal)

                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                            ZStack(alignment: .leading) {
                                if password.isEmpty {
                                    Text("Password")
                                        .foregroundColor(Color(Constants.Colors.borderColor))
                                }
                                if isPasswordVisible {
                                    TextField("", text: $password)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .foregroundColor(.black)
                                } else {
                                    SecureField("", text: $password)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .foregroundColor(.black)
                                }
                            }

                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(Constants.Colors.borderColor), lineWidth: 1)
                        )
                        .padding(.horizontal)

                        Button(action: {
                            isSignUpMode.toggle()
                        }) {
                            Text(isSignUpMode ? "Switch to Log In" : "Switch to Sign Up")
                                .foregroundColor(.blue)
                                .font(.custom(Constants.Font.defaultFontRegular, size: 16))
                        }
                    }

                    Spacer()
                }
                .font(.custom(Constants.Font.defaultFontRegular, size: 16))
                .padding()
                .navigationTitle(isSignUpMode ? "Sign Up" : "Log In")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(isPresented: $isLoggedIn) {
                    MainTabView()
                }

                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(height: 118)

                        Button(action: {
                            let deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
                            presenter.authenticate(
                                username: username,
                                password: password,
                                isSignUp: isSignUpMode,
                                deviceUUID: deviceUUID
                            ) { success, message, type in
                                if success {
                                    isLoggedIn = true
                                } else {
                                    errorMessage = message
                                    bannerType = type
                                    showTopBanner()
                                }
                            }
                        }) {
                            Text(isSignUpMode ? "Sign Up" : "Log In")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background((username.isEmpty || password.isEmpty) ? Color(Constants.Colors.disabledButtonColor).opacity(0.4) : Color(Constants.Colors.mainColor))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .font(.custom(Constants.Font.defaultFontRegular, size: 16))
                        }
                        .disabled(username.isEmpty || password.isEmpty)
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, keyboard.currentHeight)
                    .animation(.easeOut(duration: 0.25), value: keyboard.currentHeight)
                }
                .ignoresSafeArea(edges: .bottom)

                BannerView(
                    message: errorMessage ?? "",
                    type: bannerType,
                    show: $showBanner
                )
            }
        }
    }

    private func showTopBanner() {
        showBanner = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showBanner = false
            }
        }
    }
}

#Preview {
    AuthView()
}

