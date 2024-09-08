//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 09.08.2024.
//

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    static var shared: Self { get }
    func fetchPhotosNextPage(request: URLRequest?,
                             _ completion: @escaping (Result<String, Error>) -> Void)
    func changeLike(request: URLRequest?, photoId: String, _ completion: @escaping (Result<Void, Error>) -> Void)
    func clearPhotosURL()
}

final class ImagesListService: ImagesListServiceProtocol {
    // MARK: - properties
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let urlSession = URLSession.shared
    private var fetchPhotosTask: URLSessionTask?
    private var changeLikeTask: URLSessionTask?
    private let dateFormatter = DateConvertor.shared
    
    private(set) var photos = [Photo]()
    
    private init() { }
    
    // MARK: - Fetch photos
    func fetchPhotosNextPage(request: URLRequest?,
                             _ completion: @escaping (Result<String, Error>) -> Void) {
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
                let photos = object.map { Photo(photoResult: $0) }
                
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: photos)
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
                let newPhoto = Photo(photo: photo, isLiked: !photo.isLiked)
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
    
    func clearPhotosURL() {
        photos.removeAll()
    }
}
