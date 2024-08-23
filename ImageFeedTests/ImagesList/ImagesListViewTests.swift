//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 22.08.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListViewTests: XCTestCase {
    //given
    var viewController: ImagesListViewController!
    var presenter: ImagesListViewPresenterSpy!
    var imagesListService: ImagesListServiceStub!
    var dateFormatter: DateConvertorStub!
    var imagesHelper: ImagesListHelperSpy!

    override func setUpWithError() throws {
        viewController = ImagesListViewController()
        imagesListService = ImagesListServiceStub()
        dateFormatter = DateConvertorStub.shared
        imagesHelper = ImagesListHelperSpy(imagesListService: imagesListService,
                                        dateFormatter: dateFormatter)
        presenter = ImagesListViewPresenterSpy(view: viewController,
                                            imagesHelper: imagesHelper)
        viewController.presenter = presenter
    }

    override func tearDownWithError() throws {
        //then
        viewController = nil
        presenter = nil
        imagesListService = nil
        dateFormatter = nil
        imagesHelper = nil
    }
    
    //viewController calls presenter methods
//    func viewDidLoad() ++++++
//    func fetchPhotosNextPage() ++++++
//    func didTapLikeButton(cell: ImagesListCell, indexPath: IndexPath)
//    func didSelectImage(indexPath: IndexPath)
//    func getPhoto(indexPath: IndexPath) -> Photo?
//    func getPhotosCount() -> Int
//    func getStringFromDate(from date: Date) -> String
//    func updateTableViewAnimated()
    
    func testViewControllerCallsPresentersViewDidLoad() {
        //given in setUpWithError()
        
        //when
        viewController.loadViewIfNeeded()
        
        //then
        XCTAssertTrue(presenter.isViewDidLoadCalled) //behaviour verification
    }
    
    func testViewControllerCallsPresentersFetchPhotosNextPage() {
        //given in setUpWithError()
        
        //when
        viewController.loadViewIfNeeded()
        
        //then
        XCTAssertTrue(presenter.isFetchPhotosNextPageCalled)
    }
    
//    func testViewControllerCallsPresentersDidSelectImage() {
//        //given in setUpWithError()
//        let tableView = UITableView()
//        
//        //when
////        viewController.loadViewIfNeeded()
//        viewController.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
//        
//        //then
//        XCTAssertTrue(presenter.isGetPhotoCalled)
//    }
    
//    func testViewControllerCallsPresentersDidTapLikeButton() {
//        //given in setUpWithError()
//        let photosStub = (0...9).map { _ in
//            Photo(id: "Quux",
//                  size: CGSize(width: 100, height: 100),
//                  createdAt: Date(),
//                  welcomeDescription: "Quuux",
//                  fullImageURL: "Foo",
//                  largeImageURL: "Bar",
//                  smallImageURL: "Baz",
//                  thumbImageURL: "Quuuux",
//                  isLiked: false)
//        }
//        imagesHelper.photos.append(contentsOf: photosStub)
//        
//        let tableView = UITableView()
//        
//        
//        //when
//        viewController.loadViewIfNeeded()
//        viewController.imageListCellDidTapLike(UITableViewCell())
//        
//        //then
//        XCTAssertTrue(presenter.isDidTapLikeButtonCalled)
//    }
    

//    func testViewControllerCalssFetchPhotosNextPage() {
//        //given
//        let viewController = ImagesListViewController()
//        viewController.presenter = presenter
//        presenter.view = viewController
//        
//        //when
//        presenter.viewDidLoad()
//        presenter.fetchPhotosNextPage()
//        
//        //then
//        XCTAssertTrue(viewController.fetchPhotosNextPageCalled)
//    }
    
//    func testPresenterCallsShowSingleImage() {
//        //given
//        let viewController = ImagesListViewControllerSpy()
//        viewController.presenter = presenter
//        presenter.view = viewController
//        
//        //when
//        presenter.viewDidLoad()
//        presenter.didSelectImage(indexPath: IndexPath(row: 2, section: 0))
//        
//        //then
//        XCTAssertTrue(viewController.showSingleImageCalled)
//    }
    
//    func testPresenterCallsImageListCellDidTapLike() {
//        //given
//        let viewController = ImagesListViewControllerSpy()
//        viewController.presenter = presenter
//        presenter.view = viewController
//        
//        //when
//        presenter.viewDidLoad()
//        presenter?.didTapLikeButton(cell: ImagesListCell(), indexPath: IndexPath(row: 2, section: 0))
//        
//        //then
//        XCTAssertTrue(viewController.imageListCellDidTapLikeCalled)
//    }
    
//    func testPresenterCallsTableViewInsertRows() {
//        //given
//        let viewController = ImagesListViewControllerSpy()
//        viewController.presenter = presenter
//        presenter.view = viewController
//        
//        //when
//        presenter.viewDidLoad()
//        
//        //then
//        XCTAssertTrue(viewController.tableViewInsertRowsCalled)
//    }

}
