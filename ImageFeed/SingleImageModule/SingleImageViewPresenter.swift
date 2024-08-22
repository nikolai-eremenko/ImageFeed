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
    func didTapBackButton()
}

final class SingleImageViewPresenter: SingleImageViewPresenterProtocol {
    weak var view: SingleImageViewControllerProtocol?
    var fullImageURL: URL?
    var router: ImagesListRouterProtocol?
    
    init(view: SingleImageViewControllerProtocol, router: ImagesListRouterProtocol, imageURL: URL?) {
        self.view = view
        self.router = router
        self.fullImageURL = imageURL
    }
    
    func viewDidLoad() {
        setFullImageURL(imageURL: fullImageURL)
    }
    
    func setFullImageURL(imageURL: URL?) {
        guard let imageURL = imageURL else { return }
        self.view?.showFullImage(with: imageURL)
    }
    
    func didTapBackButton() {
        router?.popToRoot()
    }
}
