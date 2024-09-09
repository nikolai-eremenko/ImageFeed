//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 19.08.2024.
//

@testable import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false

    func viewDidAppear() {
        
    }
    
    func didTapLogoutButton() {
        
    }
    
    func addProfileImageServiceObserver() {
        
    }
    
    func getProfileDetails() {
        
    }
    
    func getProfileImageURL() {
        
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
}
