//
//  Profile.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 19.07.2024.
//

import Foundation

public struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(from profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = "\(profileResult.firstName) \(profileResult.lastName ?? "")"
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio
    }
    
    public init(username: String, name: String, loginName: String, bio: String?) {
        self.username = username
        self.name = name
        self.loginName = loginName
        self.bio = bio
    }
}
