//
//  AssemblyModuleBuilder.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 20.08.2024.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createProfileModule(router: ProfileRouterProtocol) -> UIViewController
    func createImagesListModule(router: ImagesListRouterProtocol) -> UIViewController
    func createSingleImageModule(with fullImageURL: URL, router: ImagesListRouterProtocol) -> UIViewController
}

final class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    func createProfileModule(router: ProfileRouterProtocol) -> UIViewController {
        let view = ProfileViewController()
        let tokenStorage = OAuth2TokenStorage.shared
        let profileService = ProfileService.shared
        let profileImageService = ProfileImageService.shared
        let presenter = ProfileViewPresenter(view: view,
                                             tokenStorage: tokenStorage,
                                             profileService: profileService,
                                             profileImageService: profileImageService,
                                             router: router)
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
    func createImagesListModule(router: ImagesListRouterProtocol) -> UIViewController {
        let view = ImagesListViewController()
        let imagesListService = ImagesListService()
        let dateFormatter = DateConvertor.shared
        let presenter = ImagesListViewPresenter(view: view,
                                                imagesListService: imagesListService,
                                                dateFormatter: dateFormatter,
                                                router: router)
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
    func createSingleImageModule(with imageURL: URL, router: ImagesListRouterProtocol) -> UIViewController {
        let view = SingleImageViewController()
        let presenter = SingleImageViewPresenter(view: view,
                                                 router: router,
                                                 imageURL: imageURL)
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
