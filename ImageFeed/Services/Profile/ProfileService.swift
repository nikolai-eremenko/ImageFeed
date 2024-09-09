//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 19.07.2024.
//

import Foundation
import WebKit
import Kingfisher

protocol ProfileServiceProtocol {
    var profile: Profile? { get set}
    func fetchProfile(request: URLRequest?, completion: @escaping (Result<Profile, Error>) -> Void)
    func logout(_ vc: ProfileViewControllerProtocol)
}

final class ProfileService: ProfileServiceProtocol {
    // MARK: - properties
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    var profile: Profile?
    
    // MARK: - Fetch profile
    func fetchProfile(request: URLRequest?, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request else {
            completion(.failure(NetworkError.invalidRequest))
            fatalError("cannot create URL")
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            print("PROFILE REQUEST: \(request)")
            
            switch result {
            case .success(let object):
                let profile = Profile(from: object)
                completion(.success(profile))
                DispatchQueue.main.async {
                    self.profile = profile
                    self.task = nil
                }
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error while fetching profile:",
                      error.localizedDescription,
                      separator: "\n")
                completion(.failure(error))
                DispatchQueue.main.async {
                    self.task = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Logout
    func logout(_ vc: ProfileViewControllerProtocol) {
        vc.dismissView()
        
        UIBlockingProgressHUD.show()
        
        /// Wait for 3 seconds and then clean cookies
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

private extension ProfileService {
    // MARK: - Clean user data
    func cleanCookies() {
        /// Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        /// Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            /// Массив полученных записей удаляем из хранилища
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
