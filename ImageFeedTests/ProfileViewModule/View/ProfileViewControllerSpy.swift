//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 19.08.2024.
//

@testable import ImageFeed
import UIKit
import Kingfisher

final class ProfileViewControllerSpy: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?

    var imageStringURL: String?
    var isShowLogoutAlertCalled: Bool = false
    var isFallureProfileDetailsCalled: Bool = false
    var isFailureProfileImageCalled: Bool = false
    var profile = Profile(username: "", name: "", loginName: "", bio: nil)
    
    func dismissView() {}
    
    func updateProfileImage(with stringURL: String?) {
        imageStringURL = stringURL
    }
    
    func failureProfileDetails(error: Error) {
        isFallureProfileDetailsCalled = true
    }
    
    func failureProfileImage(error: any Error) {
        isFailureProfileImageCalled = true
    }
    
    func showLogoutAlert(model: AlertModel) {
        isShowLogoutAlertCalled = true
    }
    
    func updateProfileDetails(with model: Profile) {
        profile = model
    }
    
}
