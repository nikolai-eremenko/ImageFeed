//
//  Configuration.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 17.08.2024.
//

import Foundation

struct Configuration {
    let apiURL: URL
    let authURL: URL
    let authorizePath: String?
    let tokenPath: String?
    let profilePath: String?
    let profileImagePath: String?
    let photosPath: String?
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    
    init(
        apiURL: URL,
        authURL: URL,
        authorizePath: String?,
        tokenPath: String?,
        profilePath: String?,
        profileImagePath: String?,
        photosPath: String?,
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String) {
            self.apiURL = apiURL
            self.authURL = authURL
            self.authorizePath = authorizePath
            self.tokenPath = tokenPath
            self.profilePath = profilePath
            self.profileImagePath = profileImagePath
            self.photosPath = photosPath
            self.accessKey = accessKey
            self.secretKey = secretKey
            self.redirectURI = redirectURI
            self.accessScope = accessScope
        }
    
    static var standard: Configuration {
        return Configuration(
            apiURL: Constants.apiURL,
            authURL: Constants.authURL,
            authorizePath: Constants.authorizePath,
            tokenPath: Constants.tokenPath,
            profilePath: Constants.profilePath,
            profileImagePath: Constants.profileImagePath,
            photosPath: Constants.photosPath,
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope
        )
    }
    
    static var mock: Configuration {
        return Configuration(
            apiURL: Constants.apiURL,
            authURL: Constants.authURL,
            authorizePath: Constants.authorizePath,
            tokenPath: Constants.tokenPath,
            profilePath: Constants.profilePath,
            profileImagePath: Constants.profileImagePath,
            photosPath: nil,
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope
        )
    }
}
