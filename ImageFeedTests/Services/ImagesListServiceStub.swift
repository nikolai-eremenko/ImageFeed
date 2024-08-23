//
//  ImagesListServiceStub.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 22.08.2024.
//

import Foundation
@testable import ImageFeed

final class ImagesListServiceStub: ImagesListServiceProtocol {
    var photos = [ImageFeed.Photo]()
    
//    private let urlSession = URLSession.shared
//    private var fetchPhotosTask: URLSessionTask?
//    private var changeLikeTask: URLSessionTask?
//    private(set) var photos = [Photo]()
//    private var lastLoadedPage: Int = 0
//    private let perPage: Int = 10
//    private let tokenStorage = OAuth2TokenStorageStub.shared
    
//    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    
    // MARK: - Fetch photos
    func fetchPhotosNextPage() {
//        assert(Thread.isMainThread)
//        
//        guard let token = tokenStorage.token else { return }
//        
//        let nextPage = lastLoadedPage + 1
//        
//        let photos = (0...9).map { _ in
//            Photo(id: "Quux",
//                  size: CGSize(width: 100, height: 100),
//                  createdAt: Date(),
//                  welcomeDescription: "Quuux",
//                  fullImageURL: "Foo",
//                  largeImageURL: "Bar",
//                  smallImageURL: "Baz",
//                  thumbImageURL: "Quuuux",
//                  isLiked: false)
//        }
//        self.photos.append(contentsOf: photos)
//        lastLoadedPage = nextPage
//        NotificationCenter.default.post(name: ImagesListServiceStub.didChangeNotification, object: self)
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
//        if let index = photos.firstIndex(where: { $0.id == photoId }) {
//            let photo = photos[index]
//            let newPhoto = Photo(photo: photo, isLiked: !photo.isLiked)
//            
//            photos = photos.withReplaced(itemAt: index, newValue: newPhoto)
//            
//            completion(.success(Void()))
//        }
    }
}
