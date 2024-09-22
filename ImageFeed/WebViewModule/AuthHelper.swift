//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 17.08.2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    private let configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest? {
        guard let request = Endpoint.authorize(config: configuration).request else {
            return nil
        }
        
        return request
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
