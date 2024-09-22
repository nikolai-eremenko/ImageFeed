//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 22.08.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListViewTests: XCTestCase {
    var imagesListService: ImagesListServiceProtocol!
    var dateFormatter: DateConvertorProtocol!
    var imagesHelper: ImagesListHelperProtocol!
    var presenter: ImagesListViewPresenterProtocol!
    var viewController: ImagesListViewController!
    var tokenStorage: OAuth2TokenStorageProtocol!
    var configuration: Configuration!

    override func setUpWithError() throws {
        imagesListService = ImagesListServiceFake()
        dateFormatter = DateConvertor.shared
        tokenStorage = OAuth2TokenStorageStub.shared
        configuration = Configuration.mock
        imagesHelper = ImagesListHelper(imagesListService: imagesListService,
                                        tokenStorage: tokenStorage,
                                        configuration: configuration)
        viewController = ImagesListViewController()
        presenter = ImagesListViewPresenter(view: viewController,
                                            imagesHelper: imagesHelper)
    }

    override func tearDownWithError() throws {
        imagesListService = nil
        dateFormatter = nil
        imagesHelper = nil
        presenter = nil
        viewController = nil
        tokenStorage = nil
    }
   
    //MARK: - ViewControllerCalls
    func testViewControllerCallsPresentersViewDidLoad() {
        //given
        let presenter = ImagesListViewPresenterSpy(view: viewController, imagesHelper: imagesHelper)
        viewController.presenter = presenter
        
        //when
        viewController.loadViewIfNeeded()
        
        //then
        XCTAssertTrue(presenter.isViewDidLoadCalled)
    }
    
    func testViewControllerCallsPresentersDidSelectImage() {
        //given
        let presenter = ImagesListViewPresenterSpy(view: viewController, imagesHelper: imagesHelper)
        viewController.presenter = presenter
        
        //when
        viewController.loadViewIfNeeded()
        let indexPath = IndexPath(row: 2, section: 0)
        presenter.didSelectImage(indexPath: indexPath)
        
        //then
        XCTAssertTrue(presenter.isDidSelectImageCalled)
    }
    
    func testViewControllerCallsPresentersFetchPhotosNextPage() {
        //given
        let presenter = ImagesListViewPresenterSpy(view: viewController, imagesHelper: imagesHelper)
        viewController.presenter = presenter
        
        //when
        viewController.loadViewIfNeeded()
        presenter.fetchPhotosNextPage()
        
        //then
        XCTAssertTrue(presenter.isFetchPhotosNextPageCalled)
    }
    
    func testViewControllerCallsPresentersGetPhoto() {
        //given
        let presenter = ImagesListViewPresenterSpy(view: viewController, imagesHelper: imagesHelper)
        viewController.presenter = presenter
        let indexPath = IndexPath(row: 2, section: 0)
        
        //when
        presenter.fetchPhotosNextPage()

        let photo = presenter.getPhoto(indexPath: indexPath)
        
        //then
        XCTAssertEqual(photo?.id, "Foo")
        XCTAssertTrue(presenter.isGetPhotoCalled)
    }
    
    func testViewControllerCallsPresentersDidTapLikeButton() {
        //given
        let presenter = ImagesListViewPresenterSpy(view: viewController, imagesHelper: imagesHelper)
        viewController.presenter = presenter
        let indexPath = IndexPath(row: 2, section: 0)
        
        //when
        viewController.loadViewIfNeeded()
        presenter.didTapLikeButton(indexPath: indexPath) { _ in }
        
        //then
        XCTAssertTrue(presenter.isDidTapLikeButtonCalled)
    }
    
    //MARK: - PresenterCalls
    func testPresenterCallsViewShowSingleImage() {
        //given
        let view = ImagesListViewControllerSpy()
        view.presenter = presenter
        
        //when
        view.loadViewIfNeeded()
        view.showSingleImage(vc: UIViewController())
        
        //then
        XCTAssertTrue(view.isShowSingleImageCalled)
    }
    
    func testPresenterCallsViewTableViewInsertRows() {
        //given
        let view = ImagesListViewControllerSpy()
        view.presenter = presenter
        let indexPaths = [IndexPath(row: 2, section: 0)]
        
        //when
        view.loadViewIfNeeded()
        view.tableViewInsertRows(at: indexPaths)
        
        //then
        XCTAssertTrue(view.isTableViewInsertRowsCalled)
    }
}
