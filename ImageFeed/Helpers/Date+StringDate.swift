//
//  Date+StringDate.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 15.08.2024.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    formatter.locale = Locale(identifier: "ru_RU")
    return formatter
}()

extension Date {
    var stringDate: String {
        var dateString = dateFormatter.string(from: self)
        dateString = dateString.replacingOccurrences(of: "г.", with: "")
        return dateString
    }
}
