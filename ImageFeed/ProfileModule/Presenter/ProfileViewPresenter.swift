//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 18.08.2024.
//

import UIKit

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func didTapLogoutButton()
    func viewDidLoad()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let tokenStorage: OAuth2TokenStorageProtocol
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    
    init(
        view: ProfileViewControllerProtocol,
        tokenStorage: OAuth2TokenStorageProtocol,
        profileService: ProfileServiceProtocol,
        profileImageService: ProfileImageServiceProtocol
    ) {
        self.view = view
        self.tokenStorage = tokenStorage
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    func viewDidLoad() {
        if let token = tokenStorage.token {
            fetchProfile(token)
        } else {
            // TODO: add alert
            switchToSplashScreen()
        }
    }
    
    func didTapLogoutButton() {
        view?.showLogoutAlert(model: getLogoutAlert())
    }
}

private extension ProfileViewPresenter {
    // MARK: - Alert
    func getLogoutAlert() -> AlertModel {
        let model = AlertModel(
            title: "Пока, пока!",
            message: "Уверенные что хотите выйти?",
            buttons: [.yesButton, .noButton],
            identifier: "Logout",
            completion: { [weak self] in
                guard
                    let self,
                    let view = self.view
                else {
                    return
                }
                self.profileService.logout(view)
            }
        )
        return model
    }
    
    // MARK: - Navigation
    func switchToSplashScreen() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
    
    // MARK: - Fetching
    func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            
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
                self.view?.updateProfileDetails(with: profile)
            case .failure(let error):
                self.view?.failureProfileDetails(error: error)
            }
        }
    }
    
    func fetchProfileImageURL(username: String) {
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let imageStringURL):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "ProfileImageURL fetched",
                      "URL: \(imageStringURL)",
                      separator: "\n")
                self.view?.updateProfileImage(with: imageStringURL)
            case .failure(let error):
                self.view?.failureProfileImage(error: error)
            }
        }
    }
}
