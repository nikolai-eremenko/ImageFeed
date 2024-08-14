//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 09.08.2024.
//

import Foundation

final class ImagesListService {
    // MARK: - properties
    
    private let urlSession = URLSession.shared
    private var fetchPhotosTask: URLSessionTask?
    private var changeLikeTask: URLSessionTask?
    private(set) var photos: [Photo] = [] {
        didSet {
            NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
        }
    }
    private var lastLoadedPage: (number: Int, total: Int)?
    private let perPage: Int = 10
    private let tokenStorage = OAuth2TokenStorage.shared
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    
    // MARK: - Fetch photos
    func fetchPhotosNextPage() {
        
        assert(Thread.isMainThread)
        
        guard let token = tokenStorage.token else { return }
        
        guard fetchPhotosTask == nil else {
            print("DEBUG",
                  "[\(String(describing: self)).\(#function)]:",
                  "Task is already in progress!",
                  separator: "\n")
            return
        }
        
        let nextPage = (lastLoadedPage?.number ?? 0) + 1
        
        guard
            let request = Endpoint.getImages(token: token, page: nextPage, perPage: perPage).request
        else {
            return
        }
        
        print("LIST IMAGES REQUEST: \(request)")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let object):
                DispatchQueue.main.async {
                    let photos = object.map { Photo(photoResult: $0) }
                    self.photos.append(contentsOf: photos)
                    self.lastLoadedPage?.number = nextPage
                    // get total from headers
//                    self.lastLoadedPage?.total = object.count
                }
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error while fetching images:",
                      error.localizedDescription,
                      separator: "\n")
            }
            DispatchQueue.main.async {
                self.fetchPhotosTask = nil
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
        
        print("CHANGE LIKE REQUEST: \(request)")
        
        let task = urlSession.dataTask(with: request) { [weak self] (data, response, error) in
            
            guard let self = self else { return }
            
            if let error = error {
                self.changeLikeTask = nil
                completion(.failure(error))
                return
            }
            
            // Поиск индекса элемента
            if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                // Текущий элемент
               let photo = self.photos[index]
               // Копия элемента с инвертированным значением isLiked.
                let newPhoto = Photo(photo: photo, isLiked: !photo.isLiked)
                // Заменяем элемент в массиве.
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
