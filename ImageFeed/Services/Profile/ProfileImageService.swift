//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 29.07.2024.
//

import Foundation

protocol ProfileImageServiceProtocol {
    func fetchProfileImageURL(request: URLRequest?, _ completion: @escaping (Result<String, Error>) -> Void)
}

final class ProfileImageService: ProfileImageServiceProtocol {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    var avatarURL: String?
    
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
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error while fetching profile image url!",
                      error.localizedDescription,
                      separator: "\n")
                
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
