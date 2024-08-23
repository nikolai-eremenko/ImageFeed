//
//  DateConvertorStub.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 22.08.2024.
//

@testable import ImageFeed
import Foundation

final class DateConvertorStub: DateConvertorProtocol {
    static var shared = DateConvertorStub()
    
    func getDateFromString(from string: String) -> Date? {
        return nil
    }
    
    func getStringFromDate(from date: Date) -> String {
        return ""
    }
}
