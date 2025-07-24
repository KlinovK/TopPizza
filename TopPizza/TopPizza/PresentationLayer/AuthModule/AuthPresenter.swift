//
//  AuthPresenter.swift
//  TopPizza
//
//  Created by Константин Клинов on 24/07/25.
//

import Foundation

protocol AuthPresenterProtocol {
    func signUp(username: String, password: String, deviceUUID: String) -> Result<Bool, AuthError>
    func logIn(username: String, password: String) -> Result<Bool, AuthError>
}

enum AuthError: LocalizedError {
    case emptyCredentials
    case usernameTaken
    case invalidCredentials
    case databaseError
    
    var errorDescription: String? {
        switch self {
        case .emptyCredentials:
            return "Username and password cannot be empty."
        case .usernameTaken:
            return "Username is already taken."
        case .invalidCredentials:
            return "Invalid username or password."
        case .databaseError:
            return "An error occurred. Please try again."
        }
    }
}

class AuthPresenter: AuthPresenterProtocol {
    
    func logIn(username: String, password: String) -> Result<Bool, AuthError> {
        guard !username.isEmpty, !password.isEmpty else {
            print("LogIn: Empty credentials provided.")
            return .failure(.emptyCredentials)
        }
        
        switch KeychainHelper.fetchUser(username: username) {
        case .success(let user):
            guard let user = user, user.password == password else {
                print("LogIn: Invalid credentials for username '\(username)'")
                return .failure(.invalidCredentials)
            }
            print("LogIn: Successfully authenticated user '\(username)'")
            return .success(true)
        case .failure:
            print("LogIn: Keychain fetch error for username '\(username)'")
            return .failure(.databaseError)
        }
    }
    
    
    func signUp(username: String, password: String, deviceUUID: String) -> Result<Bool, AuthError> {
        guard !username.isEmpty, !password.isEmpty else {
            return .failure(.emptyCredentials)
        }
        
        switch KeychainHelper.fetchUser(username: username) {
        case .success(let user):
            if user != nil {
                print("SignUp: Username '\(username)' already exists in Keychain.")
                return .failure(.usernameTaken)
            }
        case .failure:
            print("SignUp: Keychain fetch error for username '\(username)'")
            return .failure(.databaseError)
        }
        
        do {
            
            switch KeychainHelper.saveUser(username: username, password: password, deviceUUID: deviceUUID) {
            case .success:
                return .success(true)
            case .failure:
                return .failure(.databaseError)
            }
        }
        
    }
}
