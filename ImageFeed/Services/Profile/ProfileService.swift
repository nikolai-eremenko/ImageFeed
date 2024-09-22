//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 19.07.2024.
//

import Foundation

protocol ProfileServiceProtocol {
    var profile: Profile? { get set}
    func fetchProfile(request: URLRequest?, completion: @escaping (Result<Profile, Error>) -> Void)
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
                }
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error while fetching profile:",
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
