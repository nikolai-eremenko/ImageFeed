//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 21.08.2024.
//

import UIKit

protocol ImagesListViewPresenterProtocol: NSObject, UITableViewDataSource {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func didTapLikeButton(indexPath: IndexPath, _ completion: @escaping (Result<Bool, Error>) -> Void)
    func didSelectImage(indexPath: IndexPath)
    func getPhoto(indexPath: IndexPath) -> Photo?
    func getPhotosCount() -> Int
    func getStringFromDate(from date: Date) -> String
    func updateTableViewAnimated()
    func getLikeErrorAlert() -> AlertModel
}

final class ImagesListViewPresenter: NSObject, ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private let imagesHelper: ImagesListHelperProtocol
    private var imageListServiceObserver: NSObjectProtocol?

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
    }
    
    func fetchPhotosNextPage() {
        imagesHelper.fetchPhotosNextPage()
    }
    
    func getPhotosCount() -> Int {
        return imagesHelper.getPhotosCount()
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
    
    func getPhoto(indexPath: IndexPath) -> Photo? {
        return imagesHelper.getPhoto(indexPath: indexPath)
    }
    
    func getStringFromDate(from date: Date) -> String {
        return imagesHelper.getStringFromDate(from: date)
    }
    
    // MARK: - Insert rows
    func updateTableViewAnimated() {
        guard let indexPaths = imagesHelper.getInsertIndexPaths() else { return }
        
        view?.tableViewInsertRows(at: indexPaths)
    }
    
    // MARK: - Like
    func didTapLikeButton(indexPath: IndexPath, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        imagesHelper.changeLike(indexPath: indexPath)  { result in
            switch result {
            case .success(let isLiked):
                completion(.success(isLiked))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
}

// MARK: - UITableViewDataSource
extension ImagesListViewPresenter: UITableViewDataSource {
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
