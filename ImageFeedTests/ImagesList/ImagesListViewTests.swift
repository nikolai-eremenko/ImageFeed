//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 22.08.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListViewTests: XCTestCase {
    var imagesListService: ImagesListService!
    var dateFormatter: DateConvertor!
    var imagesHelper: ImagesListHelper!
    var presenter: ImagesListViewPresenter!
    var viewController: ImagesListViewController!

    override func setUpWithError() throws {
        imagesListService = ImagesListService()
        dateFormatter = DateConvertor()
        imagesHelper = ImagesListHelper(imagesListService: imagesListService, dateFormatter: dateFormatter)
        viewController = ImagesListViewController()
        presenter = ImagesListViewPresenter(view: viewController, imagesHelper: imagesHelper)
    }

    override func tearDownWithError() throws {
        imagesListService = nil
        dateFormatter = nil
        imagesHelper = nil
        viewController = nil
        presenter = nil
    }
   
    func testViewControllerCallsPresentersViewDidLoad() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy(view: viewController, imagesHelper: imagesHelper)
        viewController.presenter = presenter
        
        //when
        viewController.loadViewIfNeeded()
        
        //then
        XCTAssertTrue(presenter.isViewDidLoadCalled)
    }
    
//    func testViewControllerCallsPresentersFetchPhotosNextPage() {
//        //given
//        let viewController = ImagesListViewController()
//        let presenter = ImagesListViewPresenterSpy(view: viewController,
//                                                   imagesHelper: imagesHelper)
//        viewController.presenter = presenter
//        
//        //when
//        viewController.loadViewIfNeeded()
//        
//        //then
//        XCTAssertTrue(presenter.isFetchPhotosNextPageCalled)
//    }
//    
//    func testViewControllerCallsPresentersGetPhoto() {
//        // given
//        let viewController = ImagesListViewController()
//        let presenter = ImagesListViewPresenterSpy(view: viewController, imagesHelper: imagesHelper)
//        viewController.presenter = presenter
//        
//        // when
//        viewController.loadViewIfNeeded()
//        viewController.configCell(for: ImagesListCell(), with: IndexPath(row: 2, section: 0))
//        
//        //then
//        XCTAssertTrue(presenter.isGetPhotoCalled)
//    }
    
//    func testPresenterCallViewShowSingleImage() {
//        //given
//        let viewController = ImagesListViewControllerSpy()
//        let presenter = ImagesListViewPresenter(view: viewController, imagesHelper: imagesHelper)
//        viewController.presenter = presenter
//        presenter.view = viewController
//        imagesHelper.photos.append(contentsOf: photos)
//        
//        //when
//        presenter.didSelectImage(indexPath: IndexPath(row: 2, section: 0))
//        
//        //then
//        XCTAssertTrue(viewController.isShowSingleImageCalled)
//    }
    
//    func testPresenterReturnsIndexPathsForTableViewInsertRows() {
//        //given
//        let viewController = ImagesListViewControllerSpy()
//        let presenter = ImagesListViewPresenter(view: viewController, imagesHelper: imagesHelper)
//        viewController.presenter = presenter
//        presenter.view = viewController
//        imagesHelper.photos.append(contentsOf: photos)
//        imagesListService.photos.append(contentsOf: photos)
//        imagesListService.photos.append(contentsOf: photos)
//        
//        //when
//        presenter.updateTableViewAnimated()
//        
//        //then
//        XCTAssertEqual(viewController.receivedIndexPaths.count, photos.count)
//    }
}
