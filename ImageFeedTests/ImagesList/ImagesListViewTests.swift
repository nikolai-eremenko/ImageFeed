//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 22.08.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListViewTests: XCTestCase {
    var imagesListService: ImagesListServiceStub!
    var dateFormatter: DateConvertorStub!
    var imagesHelper: ImagesListHelperSpy!
    var photos: [Photo]!
    
    var tableView: UITableView!
    private var dataSource: UITableViewDataSource!
    private var delegate: UITableViewDelegate!

    override func setUpWithError() throws {
        imagesListService = ImagesListServiceStub()
        dateFormatter = DateConvertorStub.shared
        imagesHelper = ImagesListHelperSpy(imagesListService: imagesListService,
                                        dateFormatter: dateFormatter)
        
        photos = (0...9).map { _ in
            Photo(id: "Quux",
                  size: CGSize(width: 100, height: 100),
                  createdAt: Date(),
                  welcomeDescription: "Quuux",
                  fullImageURL: "Foo",
                  largeImageURL: "Bar",
                  smallImageURL: "Baz",
                  thumbImageURL: "Quuuux",
                  isLiked: false)
        }
    }

    override func tearDownWithError() throws {
        imagesListService = nil
        dateFormatter = nil
        imagesHelper = nil
        photos = nil
    }
    
    func testViewControllerCallsPresentersViewDidLoad() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy(view: viewController,
                                                   imagesHelper: imagesHelper)
        viewController.presenter = presenter
        
        //when
        viewController.loadViewIfNeeded()
        
        //then
        XCTAssertTrue(presenter.isViewDidLoadCalled) //behaviour verification
    }
    
    func testViewControllerCallsPresentersFetchPhotosNextPage() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy(view: viewController,
                                                   imagesHelper: imagesHelper)
        viewController.presenter = presenter
        
        //when
        viewController.loadViewIfNeeded()
        
        //then
        XCTAssertTrue(presenter.isFetchPhotosNextPageCalled)
    }
    
    func testViewControllerCallsPresentersGetPhoto() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy(view: viewController, imagesHelper: imagesHelper)
        viewController.presenter = presenter
        
        // when
        viewController.loadViewIfNeeded()
        viewController.configCell(for: ImagesListCell(), with: IndexPath(row: 2, section: 0))
        
        //then
        XCTAssertTrue(presenter.isGetPhotoCalled)
    }
    
    func testPresenterCallViewShowSingleImage() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter(view: viewController, imagesHelper: imagesHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        imagesHelper.photos.append(contentsOf: photos)
        
        //when
        presenter.didSelectImage(indexPath: IndexPath(row: 2, section: 0))
        
        //then
        XCTAssertTrue(viewController.isShowSingleImageCalled)
    }

}
