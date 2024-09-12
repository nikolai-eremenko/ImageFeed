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
    
    var profile: Profile? = nil
    var profileImageURL: String? = nil
    
    var isDidTapLogoutButtonCalled: Bool = false
    var isSwitchToSplashScreenCalled: Bool = false
    
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
    
    func switchToSplashScreen() {
        isSwitchToSplashScreenCalled = true
    }
    
    func didTapLogoutButton() {
        isDidTapLogoutButtonCalled = true
    }
    
    
    func getProfileDetails() {
        
    }
    
    func getProfileImageURL() {
        
    }
    
    // MARK: - Fetching
    private func fetchProfile() {
        profileHelper.fetchProfile { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                self.fetchProfileImageURL(username: profile.username)
                self.profile = profile
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
                self.profileImageURL = imageStringURL
            case .failure(let error):
                self.view?.failureProfileImage(error: error)
            }
        }
    }
}
