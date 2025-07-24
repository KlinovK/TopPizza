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
    @StateObject private var keyboard = KeyboardResponder()
    @State private var showBanner = false

    private let presenter = AuthPresenter()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color("MainBackground")
                    .ignoresSafeArea()

                VStack {
                    Image("ic_logo_purple")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 322, height: 101)
                        .padding(.top)

                    // Username Field
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                        ZStack(alignment: .leading) {
                            if username.isEmpty {
                                Text("Username")
                                    .foregroundColor(Color("BorderColor"))
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
                            .stroke(Color("BorderColor"), lineWidth: 1)
                    )
                    .padding(.horizontal)

                    // Password Field
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        ZStack(alignment: .leading) {
                            if password.isEmpty {
                                Text("Password")
                                    .foregroundColor(Color("BorderColor"))
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
                            .stroke(Color("BorderColor"), lineWidth: 1)
                    )
                    .padding(.horizontal)

                    // Mode switch
                    Button(action: {
                        isSignUpMode.toggle()
                    }) {
                        Text(isSignUpMode ? "Switch to Log In" : "Switch to Sign Up")
                            .foregroundColor(.blue)
                            .font(.custom("SFUIDisplay-Regular", size: 16))
                    }
                    .padding(.vertical)

                    Spacer()
                }
                .font(.custom("SFUIDisplay-Regular", size: 16))
                .padding()
                .navigationTitle(isSignUpMode ? "Sign Up" : "Log In")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(isPresented: $isLoggedIn) {
                    MainTabView()
                }

                // Bottom action button
                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(height: 118)

                        Button(action: {
                            let deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
                            let result: Result<Bool, AuthError>

                            if isSignUpMode {
                                result = presenter.signUp(username: username, password: password, deviceUUID: deviceUUID)
                            } else {
                                result = presenter.logIn(username: username, password: password)
                            }

                            switch result {
                            case .success(let success):
                                isLoggedIn = success
                                errorMessage = nil
                                showBanner = false
                                if !success {
                                    errorMessage = "No user found with these credentials."
                                    showTopBanner()
                                }
                            case .failure(let error):
                                errorMessage = error.errorDescription
                                showTopBanner()
                            }
                        }) {
                            Text(isSignUpMode ? "Sign Up" : "Log In")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background((username.isEmpty || password.isEmpty) ? Color("DisabledButtonColor").opacity(0.4) : Color("MainColor"))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .font(.custom("SFUIDisplay-Regular", size: 16))
                        }
                        .disabled(username.isEmpty || password.isEmpty)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                    }
                    .padding(.bottom, keyboard.currentHeight)
                    .animation(.easeOut(duration: 0.25), value: keyboard.currentHeight)
                }
                .ignoresSafeArea(edges: .bottom)

                if showBanner, let message = errorMessage {
                    Text(message)
                        .foregroundColor(.white)
                        .font(.custom("SFUIDisplay-Regular", size: 14))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .padding(.top, 50)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.spring(), value: showBanner)
                }
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
