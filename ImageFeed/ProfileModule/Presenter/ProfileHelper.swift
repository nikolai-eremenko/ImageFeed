//
//  ProfileHelper.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 05.09.2024.
//

import Foundation
import WebKit
import Kingfisher

protocol ProfileHelperProtocol {
    func fetchProfile(_ completion: @escaping (Result<Profile, Error>) -> Void)
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void)
    func clearUserData()
}

final class ProfileHelper: ProfileHelperProtocol {
    private let tokenStorage: OAuth2TokenStorageProtocol
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let configuration: Configuration
    
    init(
        tokenStorage: OAuth2TokenStorageProtocol,
        profileService: ProfileServiceProtocol,
        profileImageService: ProfileImageServiceProtocol,
        configuration: Configuration
    ) {
        self.tokenStorage = tokenStorage
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.configuration = configuration
    }
    
    func fetchProfile(_ completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = profileRequest()
        
        profileService.fetchProfile(request: request) { result in
            switch result {
            case .success(let profile):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Profile fetched",
                      "Profile: \(profile)",
                      separator: "\n")
                completion(.success(profile))
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error while fetching profile:",
                      error.localizedDescription,
                      separator: "\n")
                completion(.failure(error))
            }
        }
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        let request = profileImageRequest(username: username)
        
        profileImageService.fetchProfileImageURL(request: request) { result in
            switch result {
            case .success(let imageStringURL):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "ProfileImageURL fetched",
                      "URL: \(imageStringURL)",
                      separator: "\n")
                completion(.success(imageStringURL))
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error while fetching profile image url:",
                      error.localizedDescription,
                      separator: "\n")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Clean user data
    func clearUserData() {
        cleanCookies()
        cleanToken()
        cleanImageCache()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanToken() {
        tokenStorage.removeTokenKey()
    }
    
    private func cleanImageCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
    }
    
    // MARK: - Requests
    private func profileRequest() -> URLRequest? {
        guard
            let token = tokenStorage.token,
            let request = Endpoint.getProfile(config: configuration, token: token).request
        else {
            return nil
        }
        
        return request
    }
    
    private func profileImageRequest(username: String) -> URLRequest? {
        guard
            let token = tokenStorage.token,
            let request = Endpoint.getProfileImage(config: configuration, token: token, username: username).request
        else {
            return nil
        }
        
        return request
    }
}
