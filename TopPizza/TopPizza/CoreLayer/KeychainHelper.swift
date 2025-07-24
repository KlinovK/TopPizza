//
//  KeychainHelper.swift
//  TopPizza
//
//  Created by Константин Клинов on 24/07/25.
//

import Foundation


struct KeychainHelper {
    static let service = "com.example.TopPizzaApp"
    
    static func saveUser(username: String, password: String, deviceUUID: String) -> Result<Bool, AuthError> {
        let account = username
        let data = ["password": password, "deviceUUID": deviceUUID]
        guard let dataEncoded = try? JSONEncoder().encode(data) else {
            print("Keychain: Encode error for user '\(username)'")
            return .failure(.databaseError)
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: dataEncoded
        ]
        
        SecItemDelete(query as CFDictionary) // Remove existing item if any
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            print("Keychain: Saved user '\(username)' with deviceUUID '\(deviceUUID)'")
            return .success(true)
        } else {
            print("Keychain: Save error - \(status)")
            return .failure(.databaseError)
        }
    }
    
    static func fetchUser(username: String) -> Result<(password: String, deviceUUID: String)?, AuthError> {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: username,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess, let data = item as? Data {
            if let decoded = try? JSONDecoder().decode([String: String].self, from: data) {
                print("Keychain: Fetched user '\(username)'")
                return .success((password: decoded["password"] ?? "", deviceUUID: decoded["deviceUUID"] ?? ""))
            } else {
                print("Keychain: Decode error for user '\(username)'")
                return .failure(.databaseError)
            }
        } else if status == errSecItemNotFound {
            print("Keychain: User '\(username)' not found")
            return .success(nil)
        } else {
            print("Keychain: Fetch error - \(status)")
            return .failure(.databaseError)
        }
    }
    
    static func deleteUser(username: String) -> Result<Bool, AuthError> {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: username
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess || status == errSecItemNotFound {
            print("Keychain: Deleted user '\(username)'")
            return .success(true)
        } else {
            print("Keychain: Delete error - \(status)")
            return .failure(.databaseError)
        }
    }
    
    static func printAllKeychainData() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]
        
        var items: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &items)
        if status == errSecSuccess, let items = items as? [[String: Any]] {
            print("=== All Keychain Users ===")
            if items.isEmpty {
                print("No users found in Keychain.")
            } else {
                for item in items {
                    if let account = item[kSecAttrAccount as String] as? String,
                       let data = item[kSecValueData as String] as? Data,
                       let decoded = try? JSONDecoder().decode([String: String].self, from: data) {
                        print("User: username=\(account), password=\(decoded["password"] ?? ""), deviceUUID=\(decoded["deviceUUID"] ?? "")")
                    }
                }
            }
        } else {
            print("Keychain: Error fetching all users - \(status)")
        }
    }
}
