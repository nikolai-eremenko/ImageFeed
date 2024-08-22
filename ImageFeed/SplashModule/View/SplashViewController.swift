//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 10.07.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private let profileService = ProfileService.shared
    private let imageService = ProfileImageService.shared
    private let storage = OAuth2TokenStorage.shared
    private let oAuth2Service = OAuth2Service.shared
    
    // MARK: - UI Components
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ic.splashscreen")
        view.tintColor = UIColor(named: "YPWhite")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if storage.token != nil {
            switchToTabBarController()
        } else {
            switchToAuthViewController()
        }
    }
}

private extension SplashViewController {
    // MARK: - Navigation
    func switchToAuthViewController() {
        
        let authViewController = AuthViewController()
        
        authViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    func switchToTabBarController() {
        let tabBarController = TabBarController()
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        window.rootViewController = tabBarController
    }
    
    // MARK: - Constraints
    func setupViews() {
        view.backgroundColor = UIColor(named: "YPBlack")
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    SplashViewController()
}
