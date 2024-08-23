//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 09.08.2024.
//

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListService: ImagesListServiceProtocol {
    // MARK: - properties
    private let urlSession = URLSession.shared
    private var fetchPhotosTask: URLSessionTask?
    private var changeLikeTask: URLSessionTask?
    private(set) var photos = [Photo]()
    private var lastLoadedPage: Int = 0
    private let perPage: Int = 10
    private let tokenStorage = OAuth2TokenStorage.shared
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Fetch photos
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        guard let token = tokenStorage.token, fetchPhotosTask == nil else { return }
        
        let nextPage = lastLoadedPage + 1
        
        guard
            let request = Endpoint.getImages(token: token, page: nextPage, perPage: perPage).request
        else {
            print("cannot create URL")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let object):
                let photos = object.map { Photo(photoResult: $0) }
                
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: photos)
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                    self.fetchPhotosTask = nil
                }
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error while fetching images:",
                      error.localizedDescription,
                      separator: "\n")
                DispatchQueue.main.async {
                    self.fetchPhotosTask = nil
                }
            }
        }
        self.fetchPhotosTask = task
        task.resume()
    }
    
    // MARK: - Change like
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if changeLikeTask != nil {
            print("DEBUG",
                  "[\(String(describing: self)).\(#function)]:",
                  "Change like task is already in progress!",
                  separator: "\n")
            changeLikeTask?.cancel()
        }
        
        guard let token = tokenStorage.token else { return }
        
        guard
            let request = Endpoint.changeLike(photoId: photoId, isLike: isLike, token: token).request
        else {
            completion(.failure(NetworkError.invalidRequest))
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
                let newPhoto = Photo(photo: photo, isLiked: !photo.isLiked)
                DispatchQueue.main.async {
                    self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                }
                
                completion(.success(Void()))
                self.changeLikeTask = nil
            }
        }
        changeLikeTask = task
        task.resume()
    }
    
    func cleanImagesList() {
        photos.removeAll()
    }
}
