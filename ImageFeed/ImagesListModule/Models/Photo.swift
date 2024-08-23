//
//  Photo.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 09.08.2024.
//

import Foundation

struct Photo {
    private let dateFormatter = DateConvertor.shared
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let fullImageURL: String
    let largeImageURL: String
    let smallImageURL: String
    let thumbImageURL: String
    let isLiked: Bool
    
    init(photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = dateFormatter.getDateFromString(from: photoResult.createdAt)
        self.welcomeDescription = photoResult.description
        self.fullImageURL = photoResult.urls.full
        self.largeImageURL = photoResult.urls.regular
        self.smallImageURL = photoResult.urls.small
        self.thumbImageURL = photoResult.urls.thumb
        self.isLiked = photoResult.likedByUser
    }
    
    init(photo: Photo, isLiked: Bool) {
        self.id = photo.id
        self.size = photo.size
        self.createdAt = photo.createdAt
        self.welcomeDescription = photo.welcomeDescription
        self.fullImageURL = photo.fullImageURL
        self.largeImageURL = photo.largeImageURL
        self.smallImageURL = photo.smallImageURL
        self.thumbImageURL = photo.thumbImageURL
        self.isLiked = isLiked
    }
    
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
