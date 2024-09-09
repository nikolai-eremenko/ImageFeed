//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 09.08.2024.
//

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    func fetchPhotosNextPage(request: URLRequest?, _ completion: @escaping (Result<Void, Error>) -> Void)
    func changeLike(request: URLRequest?, photoId: String, _ completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListService: ImagesListServiceProtocol {
    // MARK: - properties
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let dateFormatter = DateConvertor.shared
    private let urlSession = URLSession.shared
    private var fetchPhotosTask: URLSessionTask?
    private var changeLikeTask: URLSessionTask?
    
    private(set) var photos = [Photo]()
    
    // MARK: - Fetch photos
    func fetchPhotosNextPage(request: URLRequest?, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard fetchPhotosTask == nil else {
            print("DEBUG",
                  "[\(String(describing: self)).\(#function)]:",
                  "Fetch task is already in progress",
                  separator: "\n")
            return
        }
        
        guard let request else {
            print("cannot create URL")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let object):
                let photos = object.map {
                    Photo(id: $0.id,
                          size: CGSize(width: $0.width, height: $0.height),
                          createdAt: self.dateFormatter.getDateFromString(from: $0.createdAt),
                          welcomeDescription: $0.description,
                          fullImageURL: $0.urls.full,
                          largeImageURL: $0.urls.regular,
                          smallImageURL: $0.urls.small,
                          thumbImageURL: $0.urls.thumb,
                          isLiked: $0.likedByUser)
                }
                
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: photos)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                }
                completion(.success(Void()))
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error while fetching images:",
                      error.localizedDescription,
                      separator: "\n")
                completion(.failure(error))
            }
            self.fetchPhotosTask = nil
        }
        self.fetchPhotosTask = task
        task.resume()
    }
    
    // MARK: - Change like
    func changeLike(request: URLRequest?, photoId: String, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if changeLikeTask != nil {
            print("DEBUG",
                  "[\(String(describing: self)).\(#function)]:",
                  "Change like task is already in progress!",
                  separator: "\n")
            changeLikeTask?.cancel()
        }
        
        guard let request else {
            print("cannot create URL")
            return
        }
        
        let task = urlSession.dataTask(with: request) { [weak self] (data, response, error) in
            
            guard let self else { return }
            
            if let error = error {
                self.changeLikeTask = nil
                completion(.failure(error))
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error while changing like:",
                      error.localizedDescription,
                      separator: "\n")
                return
            }
            
            if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                let photo = self.photos[index]
                let newPhoto = Photo(id: photo.id,
                                     size: photo.size,
                                     createdAt: photo.createdAt,
                                     welcomeDescription: photo.welcomeDescription,
                                     fullImageURL: photo.fullImageURL,
                                     largeImageURL: photo.largeImageURL,
                                     smallImageURL: photo.smallImageURL,
                                     thumbImageURL: photo.thumbImageURL,
                                     isLiked: !photo.isLiked)
                DispatchQueue.main.async {
                    self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                }
                
                completion(.success(Void()))
                self.changeLikeTask = nil
            }
        }
        changeLikeTask = task
        task.resume()
    }
}
