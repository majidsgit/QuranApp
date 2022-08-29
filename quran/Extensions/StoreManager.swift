//
//  StoreManager.swift
//  quran
//
//  Created by developer on 5/21/22.
//

import StoreKit
import SwiftUI

enum ProductIdentifiers: String, CaseIterable {
    
    case adFree = "com.majidjamali.quran.ad-free"
    
    static func allCasesRawValues() -> [String] {
        return ProductIdentifiers.allCases.compactMap { item in
            item.rawValue
        }
    }
}

class StoreManager: ObservableObject {
    
}
