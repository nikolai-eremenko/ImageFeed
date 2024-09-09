//
//  Photo.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 09.08.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let fullImageURL: String
    let largeImageURL: String
    let smallImageURL: String
    let thumbImageURL: String
    let isLiked: Bool
    
    init(id: String, size: CGSize, createdAt: Date?, welcomeDescription: String?, fullImageURL: String, largeImageURL: String, smallImageURL: String, thumbImageURL: String, isLiked: Bool) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.fullImageURL = fullImageURL
        self.largeImageURL = largeImageURL
        self.smallImageURL = smallImageURL
        self.thumbImageURL = thumbImageURL
        self.isLiked = isLiked
    }
}
