//
//  SingleImageViewPresenter.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 22.08.2024.
//

import Foundation

protocol SingleImageViewPresenterProtocol {
    var view: SingleImageViewControllerProtocol? { get set }
    func viewDidLoad()
    func getErrorAlert() -> AlertModel
}

final class SingleImageViewPresenter: SingleImageViewPresenterProtocol {
    weak var view: SingleImageViewControllerProtocol?
    var fullImageURL: URL?
    
    init(view: SingleImageViewControllerProtocol, imageURL: URL?) {
        self.view = view
        self.fullImageURL = imageURL
    }
    
    func viewDidLoad() {
        setFullImageURL(imageURL: fullImageURL)
    }
    
    func setFullImageURL(imageURL: URL?) {
        guard let imageURL = imageURL else { return }
        self.view?.showFullImage(with: imageURL)
    }
    
    // MARK: - Alert
    func getErrorAlert() -> AlertModel {
        let model = AlertModel(
            title: "Что-то пошло не так!",
            message: "Попробовать ещё раз?",
            buttons: [.cancelButton, .retryButton],
            identifier: "SingleImageError",
            completion: { [weak self] in
                guard
                    let self,
                    let fullImageURL = self.fullImageURL
                else { return }
                view?.showFullImage(with: fullImageURL)
            }
        )
        return model
    }
}
