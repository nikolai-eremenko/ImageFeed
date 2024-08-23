//
//  ImagesListHelperSpy.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 23.08.2024.
//

@testable import ImageFeed
import Foundation

final class ImagesListHelperSpy: ImagesListHelperProtocol {
    private let imagesListService: ImagesListServiceProtocol
    private let dateFormatter: DateConvertorProtocol
    
    init(imagesListService: ImagesListServiceProtocol, dateFormatter: DateConvertorProtocol) {
        self.imagesListService = imagesListService
        self.dateFormatter = dateFormatter
    }
    
    var photos = [Photo]()
    
    
    
    func getPhotosCount() -> Int {
        return photos.count
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func getPhoto(indexPath: IndexPath) -> ImageFeed.Photo? {
        return photos[safeIndex: indexPath.row]
    }
    
    func getStringFromDate(from date: Date) -> String {
        return dateFormatter.getStringFromDate(from: date)
    }
    
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
    
    func changeLike(indexPath: IndexPath, _ completion: @escaping (Result<Bool, any Error>) -> Void) {
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
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
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      error.localizedDescription,
                      separator: "\n")
            }
        }
    }
    
    func getImageStringURL(indexPath: IndexPath) -> String? {
        guard let photo = photos[safeIndex: indexPath.row] else { return nil }
        return photo.fullImageURL
    }
}
