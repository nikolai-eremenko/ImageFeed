//
//  Array+Extensions.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 14.08.2024.
//

import Foundation

extension Array {
    
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
    
    func withReplaced(itemAt index: Int, newValue: Element) -> [Element] {
        var array = self
        array[index] = newValue
        return array
    }
}
