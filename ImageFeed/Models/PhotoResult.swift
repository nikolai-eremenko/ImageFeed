//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 09.08.2024.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: Date
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}
