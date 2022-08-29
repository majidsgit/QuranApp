//
//  Date.swift
//  quran
//
//  Created by developer on 5/26/22.
//

import Foundation

extension Date {
    static func DateAfterAdding(days: Int, into date: Date) -> Date {
        return date.addingTimeInterval(Double(days) * 86400.0)
    }
}
