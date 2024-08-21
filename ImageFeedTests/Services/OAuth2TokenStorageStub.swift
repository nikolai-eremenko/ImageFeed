//
//  OAuth2TokenStorageStub.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 20.08.2024.
//

@testable import ImageFeed
import Foundation

final class OAuth2TokenStorageStub: OAuth2TokenStorageProtocol {
    static let shared = OAuth2TokenStorageStub()
    
    var token: String? = "Foo"
    
    private init() {}
    
    func removeTokenKey() {
        token = nil
    }
}
