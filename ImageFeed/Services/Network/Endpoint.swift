//
//  Endpoint.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 10.07.2024.
//

import Foundation

enum Endpoint {
    case authorize(config: Configuration)
    case sendCode(config: Configuration, code: String)
    case getProfile(config: Configuration, token: String)
    case getProfileImage(config: Configuration, token: String, username: String)
    case getImages(config: Configuration, token: String, page: Int, perPage: Int)
    case changeLike(config: Configuration, photoId: String, isLike: Bool, token: String)
    
    var request: URLRequest? {
        guard let url = self.url else {
            print("ERROR: cannot create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.httpBody = self.httpBody
        request.addValues(for: self)
        return request
    }
    
    private var configuration: Configuration {
        switch self {
        case .authorize(let config):
            return config
        case .sendCode(let config, _):
            return config
        case .getProfile(let config, _):
            return config
        case .getProfileImage(let config, _, _):
            return config
        case .getImages(let config, _, _, _):
            return config
        case .changeLike(let config, _, _, _):
            return config
        }
    }
    
    private var url: URL? {
        switch self {
        case .authorize, .sendCode:
            guard var components = URLComponents(string: configuration.authURL.absoluteString) else {
                assertionFailure("failed to create URLComponents")
                return nil
            }
            
            if let path = self.path {
                components.path = path
            }
            
            components.queryItems = self.queryItems
            return components.url
        case .getProfile, .getProfileImage, .getImages, .changeLike:
            guard var components = URLComponents(string: configuration.apiURL.absoluteString) else {
                assertionFailure("failed to create URLComponents")
                return nil
            }
            
            if let path = self.path {
                components.path = path
            }
            
            components.queryItems = self.queryItems
            return components.url
        }
    }
    
    private var path: String? {
        switch self {
        case .authorize:
            return configuration.authorizePath
        case .sendCode:
            return configuration.tokenPath
        case .getProfile:
            return configuration.profilePath
        case .getProfileImage(_, _, let username):
            return (configuration.profileImagePath ?? "") + username
        case .getImages:
            return configuration.photosPath
        case .changeLike(_, let photoId, _, _):
            return (configuration.photosPath ?? "") + "/" + photoId + "/like"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .authorize:
            return [
                URLQueryItem(name: "client_id", value: configuration.accessKey),
                URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: configuration.accessScope)
            ]
        case .sendCode(_, let code):
            return [
                URLQueryItem(name: "client_id", value: configuration.accessKey),
                URLQueryItem(name: "client_secret", value: configuration.secretKey),
                URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "grant_type", value: "authorization_code")
            ]
        case .getProfile, .getProfileImage, .changeLike:
            return []
        case .getImages(_, _, let page, let perPage):
            return [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(perPage))
            ]
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .authorize:
            return HTTP.Method.get.rawValue
        case .sendCode:
            return HTTP.Method.post.rawValue
        case .getProfile, .getProfileImage, .getImages:
            return HTTP.Method.get.rawValue
        case .changeLike(_, _, let isLike, _):
            return isLike ? HTTP.Method.delete.rawValue : HTTP.Method.post.rawValue
        }
    }
    
    private var httpBody: Data? {
        switch self {
        case .authorize, .sendCode, .getProfile, .getProfileImage, .getImages, .changeLike:
            return nil
            //            do {
            //                let jsonPost = try JSONEncoder().encode(code)
            //                return jsonPost
            //            } catch {
            //                print("ERROR: \(error.localizedDescription)")
            //                return nil
            //            }
        }
    }
}

// MARK: - Request
private extension URLRequest {
    /// Add HTTP headers
    /// - Parameter endpoint: Endpoint
    mutating func addValues(for endpoint: Endpoint) {
        switch endpoint {
        case .authorize:
            break
        case .sendCode:
            self.setValue(
                HTTP.Headers.Value.applicationJson.rawValue,
                forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue
            )
        case .getProfile(_, let token), .getProfileImage(_, let token, _), .getImages(_, let token, _, _), .changeLike(_, _, _, let token):
            self.setValue(
                HTTP.Headers.Value.bearer.rawValue + token,
                forHTTPHeaderField: HTTP.Headers.Key.authorization.rawValue
            )
        }
    }
}
