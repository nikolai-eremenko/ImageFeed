//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 19.08.2024.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    var viewController: ProfileViewController!
    var presenter: ProfileViewPresenterProtocol!
    var tokenStorage: OAuth2TokenStorageProtocol!
    var profileService: ProfileServiceProtocol!
    var profileImageService: ProfileImageServiceProtocol!
    var profileHelper: ProfileHelperProtocol!
    var configuration: Configuration!
    
    override func setUpWithError() throws {
        tokenStorage = OAuth2TokenStorageStub.shared
        profileService = ProfileServiceFake()
        profileImageService = ProfileImageServiceFake()
        configuration = Configuration.mock
        profileHelper = ProfileHelper(tokenStorage: tokenStorage,
                                      profileService: profileService,
                                      profileImageService: profileImageService,
                                      configuration: configuration)
        viewController = ProfileViewController()
        presenter = ProfileViewPresenter(view: viewController, profileHelper: profileHelper)
    }
    
    override func tearDownWithError() throws {
        viewController = nil
        presenter = nil
        tokenStorage = nil
        profileService = nil
        profileImageService = nil
        profileHelper = nil
    }
    
    func testViewControllerCallsPresenterViewDidAppear() {
        //given
        let presenter = ProfileViewPresenterSpy(view: viewController, profileHelper: profileHelper)
        viewController.presenter = presenter
        
        //when
        viewController.loadViewIfNeeded()
        viewController.viewDidAppear(true)
        
        //then
        XCTAssertEqual(presenter.profile?.username, "Foo")
        XCTAssertEqual(presenter.profile?.name, "Baz")
        XCTAssertEqual(presenter.profile?.loginName, "Bar")
        XCTAssertEqual(presenter.profile?.bio, "Quux")
        XCTAssertEqual(presenter.profileImageURL, "Quuuux")
    }
    
    func testViewControllerCallsPresenterDidTapLogoutButton() {
        //given
        let presenter = ProfileViewPresenterSpy(view: viewController, profileHelper: profileHelper)
        viewController.presenter = presenter
        
        //when
        viewController.loadViewIfNeeded()
        presenter.didTapLogoutButton()

        //then
        XCTAssertTrue(presenter.isDidTapLogoutButtonCalled)
    }
    
    func testPresenterCallsViewControllerShowLogoutAlert() {
        //given
        let view = ProfileViewControllerSpy()
        view.presenter = presenter
        
        let model = AlertModel(
            title: "Foo",
            message: "Baz",
            buttons: [.yesButton, .noButton],
            identifier: "Bar",
            completion: {}
        )
        
        //when
        view.loadViewIfNeeded()
        view.showLogoutAlert(model: model)
        
        //then
        XCTAssertTrue(view.isShowLogoutAlertCalled)
    }
    
    func testPresenterCallsViewControllerUpdateProfileDetail() {
        //given
        let view = ProfileViewControllerSpy()
        view.presenter = presenter
        
        let profile = Profile(username: "Foo", name: "Baz", loginName: "Bar", bio: "Quux")
        
        //when
        view.loadViewIfNeeded()
        view.updateProfileDetails(with: profile)
        
        //then
        XCTAssertEqual(view.profile.bio, profile.bio)
        XCTAssertEqual(view.profile.loginName, profile.loginName)
        XCTAssertEqual(view.profile.name, profile.name)
        XCTAssertEqual(view.profile.username, profile.username)
    }
    
    func testPresenterCallsViewControllerFailureProfileDetails() {
        //given
        let view = ProfileViewControllerSpy()
        view.presenter = presenter
        
        let error = NSError(domain: "", code: 0)
        
        //when
        view.loadViewIfNeeded()
        view.failureProfileDetails(error: error)
        
        //then
        XCTAssertTrue(view.isFallureProfileDetailsCalled)
    }
    
    func testPresenterCallsViewControllerUpdateProfileImage() {
        //given
        let view = ProfileViewControllerSpy()
        view.presenter = presenter
        
        //when
        view.loadViewIfNeeded()
        view.updateProfileImage(with: "Foo")
        
        //then
        XCTAssertEqual(view.imageStringURL, "Foo")
    }
    
    func testPresenterCallsViewControllerFailureProfileImage() {
        //given
        let view = ProfileViewControllerSpy()
        view.presenter = presenter
        let error = NSError(domain: "", code: 0)
        
        //when
        view.loadViewIfNeeded()
        view.failureProfileImage(error: error)
        
        //then
        XCTAssertTrue(view.isFailureProfileImageCalled)
    }
}
