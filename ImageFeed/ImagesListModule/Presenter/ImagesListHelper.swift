//
//  ImagesListHelper.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 22.08.2024.
//

import Foundation

protocol ImagesListHelperProtocol {
    func fetchPhotosNextPage()
    func getPhotosCount() -> Int
    func getPhoto(indexPath: IndexPath) -> Photo?
    func getInsertIndexPaths() -> [IndexPath]?
    func changeLike(indexPath: IndexPath, _ completion: @escaping (Result<Bool, Error>) -> Void)
    func getImageStringURL(indexPath: IndexPath) -> String?
}

final class ImagesListHelper: ImagesListHelperProtocol {
    private let imagesListService: ImagesListServiceProtocol
    private var tokenStorage: OAuth2TokenStorageProtocol
    
    private var photos = [Photo]()
    private var lastLoadedPage: Int = 0
    private var nextPage: Int = 0
    private let perPage: Int = 10
    
    // MARK: - Init
    init(imagesListService: ImagesListServiceProtocol,
         tokenStorage: OAuth2TokenStorageProtocol) {
        self.imagesListService = imagesListService
        self.tokenStorage = tokenStorage
    }
    
    // MARK: - Fetch photos
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage(request: imagesListRequest()) { [weak self] result in
            guard let self else { return }
                
            switch result {
            case .success:
                self.lastLoadedPage = self.nextPage
            case .failure(let error):
                // TODO: - Show error alert
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error while fetching images:",
                      error.localizedDescription,
                      separator: "\n")
            }
        }
    }
    
    // MARK: - Like
    func changeLike(indexPath: IndexPath, _ completion: @escaping (Result<Bool, Error>) -> Void)  {
        let photo = photos[indexPath.row]
        let request = changeLikesRequest(photo: photo)
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(request: request, photoId: photo.id) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.photos = self.imagesListService.photos
                    let isLiked = self.photos[indexPath.row].isLiked
                    completion(.success(isLiked))
                }
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Insert rows
    func getInsertIndexPaths() -> [IndexPath]? {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        guard oldCount != newCount else { return nil }
        
        photos = imagesListService.photos
        
        let indexPaths = (oldCount..<newCount).map { i in
            IndexPath(row: i, section: 0)
        }
        return indexPaths
    }
    
    func getImageStringURL(indexPath: IndexPath) -> String? {
        guard let photo = photos[safeIndex: indexPath.row] else { return nil }
        return photo.fullImageURL
    }
    
    func getPhotosCount() -> Int {
        return photos.count
    }
    
    func getPhoto(indexPath: IndexPath) -> Photo? {
        return photos[safeIndex: indexPath.row]
    }
}

private extension ImagesListHelper {
    // MARK: - Requests
    private func imagesListRequest() -> URLRequest?  {
        guard let token = tokenStorage.token else { return nil }
        
        nextPage = lastLoadedPage + 1
        
        guard let request = Endpoint.getImages(token: token, page: nextPage, perPage: perPage).request else {
            return nil
        }
        
        return request
    }
    
    private func changeLikesRequest(photo: Photo) -> URLRequest? {
        guard
            let token = tokenStorage.token,
            let request = Endpoint.changeLike(photoId: photo.id, isLike: photo.isLiked, token: token).request
        else {
            return nil
        }
        
        return request
    }
}
