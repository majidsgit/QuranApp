//
//  UIApplication.swift
//  quran
//
//  Created by developer on 5/17/22.
//

import Foundation
import UIKit

extension UIApplication {
    func getRootViewController() -> UIViewController {

        guard let screen = self.connectedScenes.first as? UIWindowScene else {
            return .init()
        }

        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }

        return root
    }
}
