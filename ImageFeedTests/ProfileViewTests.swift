//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 19.08.2024.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    
    var viewController: ProfileViewControllerProtocol!
    var presenter: ProfileViewPresenterProtocol!
    var tokenStorage: OAuth2TokenStorageProtocol!
    var profileService: ProfileServiceProtocol!
    var profileImageService: ProfileImageServiceProtocol!
    
    override func setUp() {
        super.setUp()
        //given
        viewController = ProfileViewController()
        tokenStorage = OAuth2TokenStorageStub.shared
        profileService = ProfileServiceStub.shared
        profileImageService = ProfileImageServiceStub.shared
        
        presenter = ProfileViewPresenter(view: viewController,
                                         tokenStorage: tokenStorage,
                                         profileService: profileService,
                                         profileImageService: profileImageService)
    }
    
    override func tearDown() {
        super.tearDown()
        viewController = nil
        presenter = nil
        tokenStorage = nil
        profileService = nil
        profileImageService = nil
    }
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
    
    func testPresenterCallsUpdateProfileDetail() {
        //given
        let viewController = ProfileViewControllerSpy()
        profileService.profile = Profile(username: "Foo", name: "Bar", loginName: "Baz", bio: "Quux")
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertEqual(viewController.profileDetails.username, "Foo")
        XCTAssertEqual(viewController.profileDetails.name, "Bar")
        XCTAssertEqual(viewController.profileDetails.loginName, "Baz")
        XCTAssertEqual(viewController.profileDetails.bio, "Quux")
    }
    
    func testPresenterCallsUpdateProfileImage() {
        //given
        let viewController = ProfileViewControllerSpy()
        profileImageService.avatarURL = "Baz"
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertEqual(viewController.imageURL, "Baz")
    }
    
    func testPresenterCallsShowLogoutAlert() {
        //given
        let viewController = ProfileViewControllerSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.didTapLogoutButton()
        
        //then
        XCTAssertTrue(viewController.showLogoutAlertCalled)
    }
}
