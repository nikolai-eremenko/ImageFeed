//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 17.08.2024.
//

import Foundation

struct AuthConfiguration {
    let authEndpoint: Endpoint
    
    init(endpoint: Endpoint) {
        self.authEndpoint = endpoint
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration( endpoint: .authorize() )
    }
}
