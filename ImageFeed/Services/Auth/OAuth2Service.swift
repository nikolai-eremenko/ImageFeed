//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 11.07.2024.
//

import Foundation

enum AuthServiceError: Error {
    case tokenNotFound
    case tokenExpired
    case tokenInvalid
}

/// Fetch an OAuth token by making a network request
final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let tokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    
    private var lastCode: String?
    private var task: URLSessionTask?
    
    private(set) var authToken: String? {
        get {
            return tokenStorage.token
        }
        set {
            tokenStorage.token = newValue
        }
    }
    
    private init() { }
    
    /// Fetch an OAuth token by making a network request
    /// - Parameters:
    ///   - code: code received from the OAuth provider
    ///   - completion: Result of the token retrieval operation
    ///
    /// It uses the NetworkClient to perform the network request, and upon receiving a response, it decodes the token from the response data using a JSONDecoder.
    /// Finally, it calls the completion handler with the result of the token retrieval operation.
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)

        guard
            lastCode != code
        else {
            completion(.failure(NetworkError.duplicateRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard
            let request = Endpoint.sendCode(config: .standard, code: code).request
        else {
            completion(.failure(NetworkError.invalidRequest))
            fatalError("cannot create URL")
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let object):
                let authToken = object.accessToken
                self.authToken = authToken
                completion(.success(authToken))
                DispatchQueue.main.async {
                    self.task = nil
                    self.lastCode = nil
                }
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Failed to fetch OAuth token:",
                      error.localizedDescription,
                      separator: "\n")
                completion(.failure(error))
                DispatchQueue.main.async {
                    self.task = nil
                    self.lastCode = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
}
