//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 19.07.2024.
//

import Foundation

enum NetworkError: Error {
    case urlSessionError
    case urlRequestError(Error)
    case invalidRequest
    case duplicateRequest
    case decodingError(Error)
    case httpStatusCode(Int)
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode, let headers = (response as? HTTPURLResponse)?.allHeaderFields {
                switch statusCode {
                case 200...299:
                    print("DEBUG",
                          "[\(String(describing: self)).\(#function)]:",
                          "- code: \(statusCode)",
                          "- headers: \(headers)",
                          separator: "\n")
                    fulfillCompletionOnTheMainThread(.success(data))
                case 400:
                    print("DEBUG",
                          "[\(String(describing: self)).\(#function)]:",
                          NetworkError.badRequest,
                          "- code \(statusCode)",
                          separator: "\n")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.badRequest))
                case 401:
                    print("DEBUG",
                          "[\(String(describing: self)).\(#function)]:",
                          NetworkError.unauthorized,
                          "- code \(statusCode)",
                          separator: "\n")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.unauthorized))
                case 403:
                    print("DEBUG",
                          "[\(String(describing: self)).\(#function)]:",
                          NetworkError.forbidden,
                          "- code \(statusCode)",
                          separator: "\n")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.forbidden))
                case 404:
                    print("DEBUG",
                          "[\(String(describing: self)).\(#function)]:",
                          NetworkError.notFound,
                          "- code \(statusCode)",
                          separator: "\n")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.notFound))
                case 500, 503:
                    print("DEBUG",
                          "[\(String(describing: self)).\(#function)]:",
                          NetworkError.serverError,
                          "- code \(statusCode)",
                          separator: "\n")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.serverError))
                default:
                    print("DEBUG",
                          "[\(String(describing: self)).\(#function)]:",
                          NetworkError.httpStatusCode(statusCode),
                          "- code \(statusCode)",
                          separator: "\n")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      NetworkError.urlRequestError(error),
                      error.localizedDescription,
                      separator: "\n")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      NetworkError.urlSessionError,
                      "Unknown error",
                      separator: "\n")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
}
