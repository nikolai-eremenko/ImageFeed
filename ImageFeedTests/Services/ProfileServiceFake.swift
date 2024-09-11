//
//  ProfileServiceFake.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 12.09.2024.
//

import Foundation
import WebKit
import Kingfisher
@testable import ImageFeed

final class ProfileServiceFake: ProfileServiceProtocol {
    // MARK: - properties
    var profile: Profile?
    
    // MARK: - Fetch profile
    func fetchProfile(request: URLRequest?, completion: @escaping (Result<Profile, Error>) -> Void) {
        let profile = Profile(username: "Foo", name: "Baz", loginName: "Bar", bio: "Quux")
        self.profile = profile
        completion(.success(profile))
    }
    
    // MARK: - Logout
    func logout(_ vc: ProfileViewControllerProtocol) {
        vc.dismissView()
        
        UIBlockingProgressHUD.show()
        
        /// Wait for 1 seconds and then clean cookies
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            self.cleanCookies()
            self.cleanToken()
            self.cleanImageCache()
            self.switchToSplashScreen()
        }
    }
}

private extension ProfileServiceFake {
    // MARK: - Clean user data
    func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    func cleanToken() {
        OAuth2TokenStorage.shared.removeTokenKey()
    }
    
    func cleanImageCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
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
