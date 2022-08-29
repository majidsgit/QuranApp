//
//  UIDevice.swift
//  quran
//
//  Created by developer on 5/13/22.
//

import UIKit

extension UIDevice {
    /// Returns `true` if the device has a notch
    static var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
    
    static var bottomIndicatorHeight: CGFloat {
        if hasNotch {
            if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                
                if UIDevice.current.orientation.isPortrait {
                    return window.safeAreaInsets.bottom
                }
                if UIDevice.current.orientation.isPortrait {
                    if window.safeAreaInsets.left > 0 {
                        return window.safeAreaInsets.left
                    } else {
                        return window.safeAreaInsets.right
                    }
                }
            }
        }
        return 0.0
    }
}
