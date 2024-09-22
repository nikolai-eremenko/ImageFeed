//
//  ImagesListServiceFake.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 10.09.2024.
//

import Foundation
@testable import ImageFeed

final class ImagesListServiceFake: ImagesListServiceProtocol {
    // MARK: - properties
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let dateFormatter = DateConvertor.shared
    
    private(set) var photos = [Photo]()
    
    func fetchPhotosNextPage(request: URLRequest?, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let photo = Photo(
            id: "Foo",
            size: CGSize(width: 200, height: 200),
            createdAt: Date(),
            welcomeDescription: "Baz",
            fullImageURL: "Bar",
            largeImageURL: "Quux",
            smallImageURL: "Quuux",
            thumbImageURL: "Quuuux",
            isLiked: false
        )
        
            for _ in 0..<10 {
                photos.append(photo)
            }
        
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
        completion(.success(()))
    }
    
    func changeLike(request: URLRequest?, photoId: String, _ completion: @escaping (Result<Void, any Error>) -> Void) {
        if let index = photos.firstIndex(where: { $0.id == photoId }) {
            let photo = photos[index]
            let newPhoto = Photo(id: photo.id,
                                 size: photo.size,
                                 createdAt: photo.createdAt,
                                 welcomeDescription: photo.welcomeDescription,
                                 fullImageURL: photo.fullImageURL,
                                 largeImageURL: photo.largeImageURL,
                                 smallImageURL: photo.smallImageURL,
                                 thumbImageURL: photo.thumbImageURL,
                                 isLiked: !photo.isLiked)
            
                photos = photos.withReplaced(itemAt: index, newValue: newPhoto)
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
            
            
            completion(.success(Void()))
        }
    }
    
}
