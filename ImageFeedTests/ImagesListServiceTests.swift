//
//  ImagesListServiceTests.swift
//  ImagesListServiceTests
//
//  Created by Nikolai Eremenko on 09.08.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    private let storage = OAuth2TokenStorage.shared
    private let service = ImagesListService.shared
    
    private func fetchPhotosNextPage(_ token: String) {
        service.fetchPhotosNextPage(token) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let photos):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Photos fetched",
                      "Count: \(photos.count)",
                      separator: "\n")
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "ProfileImageService error -",
                      error.localizedDescription,
                      separator: "\n")
                break
            }
        }
    }
    
    func testFetchPhotos() {
        
        guard let token = storage.token else { return }
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        fetchPhotosNextPage(token)
        
        wait(for: [expectation], timeout: 10)
        
//        XCTAssertEqual(service.photos.count, 10)
        
//        fetchPhotosNextPage(token)
//        
//        wait(for: [expectation], timeout: 10)
//        
//        XCTAssertEqual(service.photos.count, 20)
        
        // А чтобы проверить случай многократного вызова fetchPhotosNextPage(), просто вставьте несколько вызовов этой функции; в результате вы должны получить только одну нотификацию.
        fetchPhotosNextPage(token)
        fetchPhotosNextPage(token)
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(service.photos.count, 10)
    }
}
