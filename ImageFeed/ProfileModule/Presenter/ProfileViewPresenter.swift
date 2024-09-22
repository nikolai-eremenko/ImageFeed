//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 18.08.2024.
//

import UIKit

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func clearUserData()
    func switchToSplashScreen()
    func viewDidAppear()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileHelper: ProfileHelperProtocol
    
    init(
        view: ProfileViewControllerProtocol,
        profileHelper: ProfileHelperProtocol
    ) {
        self.view = view
        self.profileHelper = profileHelper
    }
    
    func viewDidAppear() {
        fetchProfile()
    }
    
    func clearUserData() {
        profileHelper.clearUserData()
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
    private func fetchProfile() {
        profileHelper.fetchProfile { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                self.fetchProfileImageURL(username: profile.username)
                self.view?.updateProfileDetails(with: profile)
            case .failure(let error):
                self.view?.failureProfileDetails(error: error)
            }
        }
    }
    
    private func fetchProfileImageURL(username: String) {
        profileHelper.fetchProfileImageURL(username: username) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let imageStringURL):
                self.view?.updateProfileImage(with: imageStringURL)
            case .failure(let error):
                self.view?.failureProfileImage(error: error)
            }
        }
    }
}
