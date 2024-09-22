//
//  ProfileServiceFake.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 12.09.2024.
//

import Foundation
@testable import ImageFeed

final class ProfileServiceFake: ProfileServiceProtocol {
    // MARK: - properties
    var profile: Profile?
    
    // MARK: - Fetch profile
    func fetchProfile(request: URLRequest?, completion: @escaping (Result<Profile, Error>) -> Void) {
        let profile = Profile(username: "Foo", name: "Baz", loginName: "Bar", bio: "Quux")
        self.profile = profile
        completion(.success(profile))
    }
}
