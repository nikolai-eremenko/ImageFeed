//
//  HTTP.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 10.07.2024.
//

import Foundation

enum HTTP {
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }
    
    enum Headers {
        enum Key: String {
            case contentType = "Content-Type"
            case authorization = "Authorization"
        }
        enum Value: String {
            case applicationJson = "application/json"
            case bearer = "Bearer "
        }
    }
}
