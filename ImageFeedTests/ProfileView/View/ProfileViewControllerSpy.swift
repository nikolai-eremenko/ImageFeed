//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 19.08.2024.
//

@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?

    var imageURL: String?
    var showLogoutAlertCalled: Bool = false
    var profileDetails = Profile(username: "", name: "", loginName: "", bio: "")
    
    
    
    func dismissView() {
        
    }
    
    func updateProfileImage(with stringURL: String?) {
        imageURL = stringURL
    }
    
    func failureProfileDetails(error: any Error) {
        
    }
    
    func failureProfileImage(error: any Error) {
        
    }
    
    func showLogoutAlert(model: AlertModel) {
        showLogoutAlertCalled = true
    }
    
    func updateProfileDetails(with model: ImageFeed.Profile) {
        profileDetails = model
    }
    
}
