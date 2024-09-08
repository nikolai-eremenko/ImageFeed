//
//  Constants.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 17.08.2024.
//

import Foundation

enum Constants {
    static let scheme = "https"
    static let api = "api"
    static let host = "unsplash.com"
    static let defaultBaseURL: URL = URL(staticString: "https://api.unsplash.com")
    static let port: Int? = nil
    // free access key
    static let accessKey = "9oTiliJ_ifDhqCbxo_ZPqy07nu8P8kF3dT-YKaBbkQ8"
    // free secret key
    static let secretKey = "1bKp9BHyhOnu673zLIVt__fN1EskFvBAGnQn7vc92wA"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseUrlString = "https://api.unsplash.com"
}
