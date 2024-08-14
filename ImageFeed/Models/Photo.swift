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
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = photoResult.createdAt
        self.welcomeDescription = photoResult.description
        self.fullImageURL = photoResult.urls.full
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.regular
        self.isLiked = photoResult.likedByUser
    }
    
    init(photo: Photo, isLiked: Bool) {
        self.id = photo.id
        self.size = photo.size
        self.createdAt = photo.createdAt
        self.welcomeDescription = photo.welcomeDescription
        self.fullImageURL = photo.fullImageURL
        self.thumbImageURL = photo.thumbImageURL
        self.largeImageURL = photo.largeImageURL
        self.isLiked = isLiked
    }
}
