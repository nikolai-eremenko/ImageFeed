//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Nikolai Eremenko on 23.08.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    /// тестируем сценарий авторизации
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("")    // add your email
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("")  // add your password
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        /// печатает в консоли дерево UI-элементов
        print(app.debugDescription)

        ///  вернёт таблицы на экран
        let tablesQuery = app.tables
        /// вернёт ячейку по индексу 0
        tablesQuery.children(matching: .cell).element(boundBy: 0)
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    /// тестируем сценарий ленты
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(4)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["likeButtonIsNotLiked"].tap()
        sleep(2)
        cellToLike.buttons["likeButtonIsLiked"].tap()
        
        sleep(3)
        
        cellToLike.tap()
        
        sleep(3)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["BackButton"]
        navBackButtonWhiteButton.tap()
    }
    
    /// тестируем сценарий профиля
    func testProfile() throws {
        sleep(5)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        sleep(5)
        XCTAssertTrue(app.staticTexts[""].exists)     // add your "Name Surname"
        XCTAssertTrue(app.staticTexts["@"].exists)    // add your "@username"
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["Logout"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
