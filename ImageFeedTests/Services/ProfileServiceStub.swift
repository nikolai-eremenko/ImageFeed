//
//  ProfileServiceStub.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 20.08.2024.
//

@testable import ImageFeed
import Foundation

final class ProfileServiceStub: ProfileServiceProtocol {
    static let shared = ProfileServiceStub()
    var profile: Profile? = Profile(username: "Baz", name: "Foo", loginName: "Bar", bio: "Quuux")
    
    private init() {}
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, any Error>) -> Void) {
        completion(.success(profile!))
    }
    
    func logout(_ vc: any ProfileViewControllerProtocol) {
        
    }
}
