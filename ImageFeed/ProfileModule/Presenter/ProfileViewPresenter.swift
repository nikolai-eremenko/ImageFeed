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
    
    func didTapLogoutButton() {
        view?.showLogoutAlert(model: getLogoutAlert())
    }
    
    // MARK: - Alert
    private func getLogoutAlert() -> AlertModel {
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
                self.profileHelper.clearUserData(vc: view)
            }
        )
        return model
    }
    
    // MARK: - Navigation
//    private func switchToSplashScreen() {
//        if !profileHelper.isAuthorized() {
//            guard let window = UIApplication.shared.windows.first else {
//                assertionFailure("Invalid window configuration")
//                return
//            }
//            window.rootViewController = SplashViewController()
//            window.makeKeyAndVisible()
//            UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
//        }
//    }
    
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
