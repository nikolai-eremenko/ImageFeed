//
//  ProfileImageServiceFake.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 12.09.2024.
//

import Foundation
@testable import ImageFeed

final class ProfileImageServiceFake: ProfileImageServiceProtocol {
    var avatarURL: String?
    
    func fetchProfileImageURL(request: URLRequest?, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        let profileImageURL = "Quuuux"
        avatarURL = profileImageURL
        completion(.success(profileImageURL))
    }
}
