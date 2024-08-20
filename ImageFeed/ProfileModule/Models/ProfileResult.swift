//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 25.07.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}
