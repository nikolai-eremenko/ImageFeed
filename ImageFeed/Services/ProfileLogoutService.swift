//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 14.08.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private let imagesListService = ImagesListService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        cleanUserData()
        switchToSplashScreen()
    }
}

private extension ProfileLogoutService {
    func cleanCookies() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    func cleanUserData() {
        ProfileService.shared.cleanProfile()
        ProfileImageService.shared.cleanProfileImage()
        imagesListService.cleanImagesList()
        OAuth2TokenStorage.shared.removeTokenKey()
    }
    
    func switchToSplashScreen() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
}
