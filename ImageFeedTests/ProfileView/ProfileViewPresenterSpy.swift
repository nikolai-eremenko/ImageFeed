//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 19.08.2024.
//

import Foundation

import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    var setAvatarURLCalled: Bool = false
    var setProfileDetailsCalled: Bool = false
    var addProfileImageServiceObserverCalled: Bool = false
    
    func getAvatarURL() {
        setAvatarURLCalled = true
    }
    
    func getProfileDetails() { 
        setProfileDetailsCalled = true
    }
    
    func addProfileImageServiceObserver() {
        addProfileImageServiceObserverCalled = true
    }
    
    func didTapLogoutButton() {
        
    }
    
}
