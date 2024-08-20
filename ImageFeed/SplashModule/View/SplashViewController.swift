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
        if let token = storage.token {
            fetchProfile(token)
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
    
    // MARK: - Fetching
    func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Profile fetched",
                      "Username: \(profile.username)",
                      "Name: \(profile.name)",
                      "LoginName: \(profile.loginName)",
                      "Bio: \(profile.bio ?? "nil")",
                      separator: "\n")
                self.fetchProfileImageURL(username: profile.username)
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "ProfileService error -",
                      error.localizedDescription,
                      separator: "\n")
                break
            }
        }
    }
    
    private func fetchProfileImageURL(username: String) {
        imageService.fetchProfileImageURL(username: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let imageStringURL):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "ProfileImageURL fetched",
                      "URL: \(imageStringURL)",
                      separator: "\n")
                self.switchToTabBarController()
                dismiss(animated: true)
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "ProfileImageService error -",
                      error.localizedDescription,
                      separator: "\n")
                break
            }
        }
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
