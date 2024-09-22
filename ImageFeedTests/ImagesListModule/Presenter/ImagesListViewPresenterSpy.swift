//
//  ImagesListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 22.08.2024.
//

@testable import ImageFeed
import UIKit

final class ImagesListViewPresenterSpy: NSObject, ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private let imagesHelper: ImagesListHelperProtocol
    private var imageListServiceObserver: NSObjectProtocol?
    
    var isViewDidLoadCalled = false
    var isDidSelectImageCalled = false
    var isFetchPhotosNextPageCalled = false
    var isDidTapLikeButtonCalled = false
    var isGetPhotoCalled = false
    
    init(
        view: ImagesListViewControllerProtocol,
        imagesHelper: ImagesListHelperProtocol
    ) {
        self.view = view
        self.imagesHelper = imagesHelper
    }
    
    func viewDidLoad() {
        addImageListServiceObserver()
        fetchPhotosNextPage()
        isViewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        imagesHelper.fetchPhotosNextPage()
        isFetchPhotosNextPageCalled = true
    }
    
    func getPhotosCount() -> Int {
        return imagesHelper.getPhotosCount()
    }
    
    func didSelectImage(indexPath: IndexPath) {
        isDidSelectImageCalled = true
    }
    
    func getPhoto(indexPath: IndexPath) -> Photo? {
        isGetPhotoCalled = true
        return imagesHelper.getPhoto(indexPath: indexPath)
    }
    
    func updateTableViewAnimated() { }
    
    func didTapLikeButton(indexPath: IndexPath, _ completion: @escaping (Result<Bool, any Error>) -> Void) {
        isDidTapLikeButtonCalled = true
    }
    
    func getLikeErrorAlert() -> AlertModel {
        let model = AlertModel(
            title: "Ошибка!",
            message: "Не удалось поставить лайк",
            buttons: [.okButton],
            identifier: "LikeError",
            completion: { }
        )
        return model
    }
    
    // MARK: - Notifications
    func addImageListServiceObserver() {
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            
            self.updateTableViewAnimated()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesHelper.getPhotosCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as! ImagesListCell
        cell.delegate = self.view
        cell.configure(with: imagesHelper.getPhoto(indexPath: indexPath)!)
        return cell
    }
}
