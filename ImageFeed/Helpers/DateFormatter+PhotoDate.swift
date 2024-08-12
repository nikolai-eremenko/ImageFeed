//
//  DateFormatter+PhotoDate.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 09.08.2024.
//

import Foundation

extension DateFormatter {
    static let photoDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
}

