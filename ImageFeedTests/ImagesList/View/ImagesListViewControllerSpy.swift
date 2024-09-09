//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 22.08.2024.
//

import UIKit
import Kingfisher
@testable import ImageFeed

final class ImagesListViewControllerSpy: UIViewController, ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    
    var isShowSingleImageCalled = false
    var isTableViewInsertRowsCalled = false
//    var receivedIndexPaths = [IndexPath]()
    
//    var isTableViewInsertRowsCalled = false
    
    // MARK: - Cell
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
    }
    
    func tableViewInsertRows(at indexPaths: [IndexPath]) {
//        receivedIndexPaths = indexPaths
        isTableViewInsertRowsCalled = true
    }
    
    func showSingleImage(vc: UIViewController) {
        isShowSingleImageCalled = true
    }
    
    // MARK: - Alerts
    func showLikeErrorAlert(model: AlertModel) {
        AlertPresenter.showAlert(on: self, model: model)
    }
    
}

// MARK: - UITableViewDelegate
extension ImagesListViewControllerSpy: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.getPhoto(indexPath: indexPath) else { return 200 }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectImage(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewControllerSpy: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
    }
}
