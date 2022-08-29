//
//  Data+String.swift
//  quran
//
//  Created by developer on 5/13/22.
//

import Foundation

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
