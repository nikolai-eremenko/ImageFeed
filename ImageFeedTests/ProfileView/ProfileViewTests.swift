//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 19.08.2024.
//

import Foundation

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsPresenter() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.setProfileDetailsCalled)
        XCTAssertTrue(presenter.setAvatarURLCalled)
        XCTAssertTrue(presenter.addProfileImageServiceObserverCalled)
    }
    
    func testPresenterCallsUpdateProfileDetails() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter(view: viewController)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.getProfileDetails()
        
        //then
        XCTAssertTrue(viewController.updateProfileDetailsCalled)
    }
    
    func testPresenterCallsUpdateAvatar() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter(view: viewController)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.getAvatarURL()
        
        //then
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
}
