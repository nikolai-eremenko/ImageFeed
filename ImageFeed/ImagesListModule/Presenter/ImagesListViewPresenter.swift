//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 21.08.2024.
//

import Foundation

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    var dateFormatter: DateConvertorProtocol { get }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func didTapLikeButton(cell: ImagesListCell)
    func tapOnImage(imageURL: URL?)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var router: ImagesListRouterProtocol?
    let dateFormatter: DateConvertorProtocol
    private let imagesListService: ImagesListServiceProtocol
    private var imageListServiceObserver: NSObjectProtocol?
    var photos = [Photo]()

    init(
        view: ImagesListViewControllerProtocol,
        imagesListService: ImagesListServiceProtocol,
        dateFormatter: DateConvertorProtocol,
        router: ImagesListRouterProtocol
    ) {
        self.view = view
        self.imagesListService = imagesListService
        self.dateFormatter = dateFormatter
        self.router = router
    }
    
    func viewDidLoad() {
        addImageListServiceObserver()
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func tapOnImage(imageURL: URL?) {
        router?.showSingleImage(imageURL: imageURL)
    }
    
    // MARK: - Like
    func didTapLikeButton(cell: ImagesListCell) {
        guard let indexPath = view?.tableView.indexPath(for: cell) else { return }
        
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.photos = self.imagesListService.photos
                    cell.setIsLiked(self.photos[indexPath.row].isLiked)
                }
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      error.localizedDescription,
                      separator: "\n")
                self.view?.showLikeErrorAlert(model: self.getLikeErrorAlert())
            }
        }
    }
}

private extension ImagesListViewPresenter {
    // MARK: - Notifications
    private func addImageListServiceObserver() {
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }

            self.updateTableViewAnimated()
        }
    }
    
    // MARK: - Insert rows
    func updateTableViewAnimated() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let oldCount = self.photos.count
            let newCount = self.imagesListService.photos.count
            if oldCount != newCount {
                self.photos = self.imagesListService.photos
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                self.view?.tableView.performBatchUpdates {
                    self.view?.tableView.insertRows(at: indexPaths, with: .automatic)
                } completion: { _ in }
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
}
