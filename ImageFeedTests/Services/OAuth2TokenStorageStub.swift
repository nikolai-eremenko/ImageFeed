//
//  OAuth2TokenStorageStub.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 10.09.2024.
//

import Foundation
@testable import ImageFeed

final class OAuth2TokenStorageStub: OAuth2TokenStorageProtocol {
    static let shared = OAuth2TokenStorageStub()
    
    var token: String? = "Foo"
    
    private init() {}
    
    func removeTokenKey() {
        
    }
}
