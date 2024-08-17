//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 19.07.2024.
//

import Foundation

final class ProfileService {
    // MARK: - properties
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    // MARK: - Init
    private init() { }
    
    // MARK: - Public methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard
            let request = Endpoint.getProfile(token: token).request
        else {
            completion(.failure(NetworkError.invalidRequest))
            fatalError("cannot create URL")
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            print("PROFILE REQUEST: \(request)")
            
            switch result {
            case .success(let object):
                let profile = Profile(from: object)
                self.profile = profile
                completion(.success(profile))
                DispatchQueue.main.async {
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
    
    func cleanProfile() {
        profile = nil
    }
}
