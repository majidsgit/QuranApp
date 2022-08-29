//
//  View.swift
//  quran
//
//  Created by developer on 5/16/22.
//

import SwiftUI

extension View {
    
    func snapshot() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        
        let targetSize = controller.view.intrinsicContentSize
        controller.view.frame = CGRect(origin: .zero, size: targetSize)
        controller.view.backgroundColor = .purple

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            controller.view.drawHierarchy(in: controller.view.frame, afterScreenUpdates: true)
        }
    }
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
}
