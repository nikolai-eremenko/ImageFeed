//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 09.07.2024.
//

import SwiftKeychainWrapper

protocol OAuth2TokenStorageProtocol {
    static var shared: Self { get }
    var token: String? { get set }
    func removeTokenKey()
}

struct KeychainKeys {
     static let tokenKey: String = "token"
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    static let shared = OAuth2TokenStorage()
    private var keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: KeychainKeys.tokenKey)
        }
        set {
            if let token = newValue {
                let isSuccess = keychainWrapper.set(token, forKey: KeychainKeys.tokenKey)
                guard isSuccess else {
                    print("DEBUG:",
                          "[\(String(describing: self)).\(#function)]:",
                          "Error saving token to keychain",
                          separator: "\n")
                    return
                }
            } else {
                keychainWrapper.removeObject(forKey: KeychainKeys.tokenKey)
            }
        }
    }
    
    private init() {}
    
    /// Removes token key from the keychain
    func removeTokenKey() {
        let isSuccess = keychainWrapper.removeObject(forKey: KeychainKeys.tokenKey)
        guard isSuccess else {
            print("DEBUG:",
                  "[\(String(describing: self)).\(#function)]:",
                  "Error removing token from keychain",
                  separator: "\n")
            return
        }
    }
}
