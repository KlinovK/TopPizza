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
    func authenticate(
        username: String,
        password: String,
        isSignUp: Bool,
        deviceUUID: String,
        completion: (Bool, String?, BannerType) -> Void
    )
}

enum AuthError: LocalizedError {
    case emptyCredentials
    case usernameTaken
    case invalidCredentials
    case databaseError

    var errorDescription: String? {
        switch self {
        case .emptyCredentials:
            return "Username and password cannot be empty"
        case .usernameTaken:
            return "Username is already taken"
        case .invalidCredentials:
            return "Invalid username or password"
        case .databaseError:
            return "An error occurred. Please try again"
        }
    }
}

class AuthPresenter: AuthPresenterProtocol {
    
    func logIn(username: String, password: String) -> Result<Bool, AuthError> {
        guard !username.isEmpty, !password.isEmpty else {
            return .failure(.emptyCredentials)
        }

        switch KeychainHelper.fetchUser(username: username) {
        case .success(let user):
            guard let user = user, user.password == password else {
                return .failure(.invalidCredentials)
            }
            return .success(true)
        case .failure:
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
                return .failure(.usernameTaken)
            }
        case .failure:
            return .failure(.databaseError)
        }

        switch KeychainHelper.saveUser(username: username, password: password, deviceUUID: deviceUUID) {
        case .success:
            return .success(true)
        case .failure:
            return .failure(.databaseError)
        }
    }

    func authenticate(
        username: String,
        password: String,
        isSignUp: Bool,
        deviceUUID: String,
        completion: (Bool, String?, BannerType) -> Void
    ) {
        let result = isSignUp
            ? signUp(username: username, password: password, deviceUUID: deviceUUID)
            : logIn(username: username, password: password)

        switch result {
        case .success(let success):
            if success {
                completion(true, nil, .success)
            } else {
                completion(false, "Authentication failed.", .error)
            }
        case .failure(let error):
            completion(false, error.errorDescription, .error)
        }
    }
}
