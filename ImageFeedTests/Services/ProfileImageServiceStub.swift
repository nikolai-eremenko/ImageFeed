//
//  ProfileImageServiceStub.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 20.08.2024.
//

@testable import ImageFeed
import Foundation

final class ProfileImageServiceStub: ProfileImageServiceProtocol {
//    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    static let shared = ProfileImageServiceStub()
    
    var avatarURL: String? = "Quuux"
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, any Error>) -> Void) {
        completion(.success(avatarURL!))
    }
    
    func clearProfileImageURL() {
        
    }
}
