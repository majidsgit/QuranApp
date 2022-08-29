//
//  HeaderSectionView.swift
//  quran
//
//  Created by developer on 5/13/22.
//

import SwiftUI

struct HeaderSectionView: View {
    // MARK : - PROPERTIES
    let textAspect = 1.0
    
    @Environment(\.presentationMode) var presentationMode
    
    let headerYMargin = UIDevice.hasNotch ? 15.0 : 20.0 * UIScreen.main.bounds.height / 812.0
    let headerButtonHeight = 24.0 * UIScreen.main.bounds.height / 812.0
    
    let content: String
    let leftItem: String
    
    let onLeftItemTap: () -> Void
    
    
    // MARK: - BODY
    var body: some View {
        HeaderView()
    }
    
    
    // MARK: - VIEWS
    
    
    
    
    // MARK: - HeaderView
    @ViewBuilder
    func HeaderItems(image: String) -> some View {
        Image(image)
            .renderingMode(.template)
            .foregroundColor(Color("navigationbar-button"))
            .aspectRatio(contentMode: .fit)
            .frame(height: headerButtonHeight)
    }
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(alignment: .center, spacing: 24.0) {
            HeaderItems(image: leftItem)
                .onTapGesture {
                    onLeftItemTap()
                    presentationMode.wrappedValue.dismiss()
                }
            Text(content)
                .font(.custom("Poppins-Bold", size: 20 * textAspect))
                .foregroundColor(Color("navigationbar-text"))
            Spacer()
//            HeaderItems(image: "search")
//                .onTapGesture {
//
//                }
        }
        .padding(.top, headerYMargin)
    }
}



// MARK: - PREVIEWS
struct HeaderSectionView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderSectionView(content: "Quran App", leftItem: "") {
            
        }
    }
}
