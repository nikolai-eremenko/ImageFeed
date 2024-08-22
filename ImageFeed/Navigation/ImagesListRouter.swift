//
//  ImagesListRouter.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 22.08.2024.
//

import UIKit

protocol ImagesListRouterProtocol: RouterMainProtocol {
//    var navigationController: UINavigationController? { get set }
    func initialViewController()
    func showSingleImage(imageURL: URL?)
    func popToRoot()
}

class ImagesListRouter: ImagesListRouterProtocol {
//    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(/*navigationController: UINavigationController,*/ assemblyBuilder: AssemblyBuilderProtocol) {
//        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
//        if let navigationController = navigationController {
            guard let imagesListViewController = assemblyBuilder?.createImagesListModule(router: self) else { return }
            navigationController.viewControllers = [imagesListViewController]
//        }
    }
    
    func showSingleImage(imageURL: URL?) {
        if let navigationController = navigationController {
            guard let imageURL = imageURL else { return }
            guard let singleImageViewController = assemblyBuilder?.createSingleImageModule(with: imageURL, router: self) else { return }
            navigationController.modalPresentationStyle = .overFullScreen
            navigationController.present(singleImageViewController, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
