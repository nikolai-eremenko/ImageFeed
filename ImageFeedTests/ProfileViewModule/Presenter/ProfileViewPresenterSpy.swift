//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 19.08.2024.
//

@testable import ImageFeed
import UIKit

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileHelper: ProfileHelperProtocol
    
    var isViewDidLoadCalled: Bool = false
    var isViewDidAppearCalled: Bool = false
    var isDidTapLogoutButtonCalled: Bool = false
    
    init(
        view: ProfileViewControllerProtocol,
        profileHelper: ProfileHelperProtocol
    ) {
        self.view = view
        self.profileHelper = profileHelper
    }
    
    func viewDidLoad() {
        if !profileHelper.isAuthorized() {
            switchToSplashScreen()
        }
        
        isViewDidLoadCalled = true
    }
    
    func viewDidAppear() {
        isViewDidAppearCalled = true
    }
    
    func didTapLogoutButton() {
        isDidTapLogoutButtonCalled = true
    }
    
    func addProfileImageServiceObserver() {
        
    }
    
    func getProfileDetails() {
        
    }
    
    func getProfileImageURL() {
        
    }
}

private extension ProfileViewPresenterSpy {
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
                self.profileHelper.clearUserData(vc: view)
            }
        )
        return model
    }
    
    // MARK: - Navigation
    func switchToSplashScreen() {
    }
    
    // MARK: - Fetching
    func fetchProfile() {
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
    
    func fetchProfileImageURL(username: String) {
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
