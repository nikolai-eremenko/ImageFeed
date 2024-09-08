//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 29.07.2024.
//

import Foundation

protocol ProfileImageServiceProtocol {
    static var shared: Self { get }
    var avatarURL: String? { get set }
    func fetchProfileImageURL(request: URLRequest?, _ completion: @escaping (Result<String, Error>) -> Void)
    func clearProfileImageURL()
}

final class ProfileImageService: ProfileImageServiceProtocol {
    static let shared = ProfileImageService()
    
    private let storage = OAuth2TokenStorage.shared
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    var avatarURL: String?
    
    private init() { }
    
    func fetchProfileImageURL(request: URLRequest?, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
   
        guard let request else {
            completion(.failure(NetworkError.invalidRequest))
            fatalError("cannot create URL")
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let object):
                let profileImageURL = object.profileImage.large
                completion(.success(profileImageURL))
                
                self.avatarURL = profileImageURL
                
                DispatchQueue.main.async {
                    self.task = nil
                }
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error while fetching profile image url!",
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
    
    func clearProfileImageURL() {
        avatarURL = nil
    }
}
