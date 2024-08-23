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
//    private var imageListServiceObserver: NSObjectProtocol?
    
    var isViewDidLoadCalled = false
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
        
//        addImageListServiceObserver()
        fetchPhotosNextPage()
    }
    func fetchPhotosNextPage() {
        isFetchPhotosNextPageCalled = true
//        imagesHelper.fetchPhotosNextPage()
    }
    
    func updateTableViewAnimated() {
//        guard let indexPaths = imagesHelper.getInsertIndexPaths() else { return }
//        
//        view?.tableViewInsertRows(at: indexPaths)
    }
    
    func getPhoto(indexPath: IndexPath) -> Photo? {
        isGetPhotoCalled = true
        return imagesHelper.getPhoto(indexPath: indexPath)
    }
    
    
    // MARK: - Like
    func didTapLikeButton(indexPath: IndexPath, _ completion: @escaping (Result<Bool, any Error>) -> Void) {
        isDidTapLikeButtonCalled = true
    }
    
    func getPhotosCount() -> Int {
        return imagesHelper.getPhotosCount()
    }
    
    func getStringFromDate(from date: Date) -> String {
        return imagesHelper.getStringFromDate(from: date)
    }
    
    func didSelectImage(indexPath: IndexPath) {
        guard
            let stringURL = imagesHelper.getImageStringURL(indexPath: indexPath),
            let imageURL = URL(string: stringURL)
        else {
            return
        }
        
        let viewController = SingleImageViewController()
        let presenter = SingleImageViewPresenter(view: viewController, imageURL: imageURL)
        viewController.presenter = presenter
        presenter.view = viewController
        
        viewController.modalPresentationStyle = .fullScreen
        
        view?.showSingleImage(vc: viewController)
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
    
    // MARK: - Notifications
//    private func addImageListServiceObserver() {
//        imageListServiceObserver = NotificationCenter.default.addObserver(
//            forName: ImagesListService.didChangeNotification,
//            object: nil,
//            queue: .main
//        ) { [weak self] _ in
//            guard let self else { return }
//            
//            self.updateTableViewAnimated()
//        }
//    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewPresenterSpy: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesHelper.getPhotosCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell {
            cell.delegate = view
            view?.configCell(for: cell, with: indexPath)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
