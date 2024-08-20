//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 19.08.2024.
//

import Foundation

@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?

    var updateProfileDetailsCalled: Bool = false
    var updateAvatarCalled: Bool = false
    
    func updateProfileDetails(with model: Profile) {
        updateProfileDetailsCalled = true
    }
    
    func updateAvatar(with url: URL) {
        updateAvatarCalled = true
    }
    
    func showLogoutAlert(model: AlertModel) {
        
    }
    
}
