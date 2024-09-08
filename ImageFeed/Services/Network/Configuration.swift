//
//  Configuration.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 17.08.2024.
//

import Foundation

struct Configuration {
    let scheme: String
    let api: String
    let host: String
    let port: Int?
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    
    init(scheme: String,
         api: String,
         host: String,
         port: Int?,
         accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String) {
        self.scheme = scheme
        self.api = api
        self.host = host
        self.port = port
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
    }
    
    static var standard: Configuration {
        return Configuration(
            scheme: Constants.scheme,
            api: Constants.api,
            host: Constants.host,
            port: Constants.port,
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope
        )
    }
}
