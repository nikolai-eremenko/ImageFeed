//
//  ModuleBuilder.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 20.08.2024.
//

import UIKit

protocol Builder {
    static func createProfileModule() -> UIViewController
}

final class ModuleBuilder: Builder {
    static func createProfileModule() -> UIViewController {
        let view = ProfileViewController()
        let tokenStorage = OAuth2TokenStorage.shared
        let profileService = ProfileService.shared
        let profileImageService = ProfileImageService.shared
        
        let presenter = ProfileViewPresenter(view: view,
                                             tokenStorage: tokenStorage,
                                             profileService: profileService,
                                             profileImageService: profileImageService)
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
