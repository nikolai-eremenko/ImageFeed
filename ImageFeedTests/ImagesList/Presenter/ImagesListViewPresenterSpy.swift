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
        isViewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        imagesHelper.fetchPhotosNextPage()
        isFetchPhotosNextPageCalled = true
    }
    
    func updateTableViewAnimated() {
    }
    
    func getPhoto(indexPath: IndexPath) -> Photo? {
        isGetPhotoCalled = true
        return imagesHelper.getPhoto(indexPath: indexPath)
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
    
    // MARK: - Like
    func didTapLikeButton(indexPath: IndexPath, _ completion: @escaping (Result<Bool, any Error>) -> Void) {
        isDidTapLikeButtonCalled = true
    }
    
    func getPhotosCount() -> Int {
        return imagesHelper.getPhotosCount()
    }
    
    func didSelectImage(indexPath: IndexPath) {
        isDidSelectImageCalled = true
    }
    
    // MARK: - Alert
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
}
