//
//  TabsView.swift
//  iQuran-Simple Quran App
//
//  Created by developer on 4/30/22.
//

import SwiftUI

struct TabsView: View {
    // MARK: - PROPERTIES
    @State private var selectedTab = "home"
    let tabBarHeight = 70 * UIScreen.main.bounds.height / 812.0
    let tabItemHeight = 32.0 * UIScreen.main.bounds.height / 812.0
    
    
    // MARK: - BODY
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                if(selectedTab == "home") {
                    AnyView(
                        HomeView()
                    )
                } else {
                    AnyView(
                        BookmarkView()
                    )
                }
                VStack(spacing: 0) {
                    Spacer()
                    tabBar()
                    if (UIDevice.hasNotch) {
                        Color("tabbar-bg")
                            .frame(width: UIScreen.main.bounds.width, height: UIDevice.bottomIndicatorHeight)
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
    
    
    
    
    // MARK: - VIEWS
    @ViewBuilder
    func tabBarItem(image: String) -> some View {
        Image(image)
            .renderingMode(.template)
            .foregroundColor(selectedTab == image ? Color("tabbar-selected-item") : Color("tabbar-not-selected-item"))
            .aspectRatio(1.0, contentMode: .fit)
            .frame(height: tabItemHeight)
            .onTapGesture {
                selectedTab = image
            }
    }
    
    @ViewBuilder
    func tabBar() -> some View {
        HStack(alignment: .center) {
            Spacer()
            tabBarItem(image: "home")
            Spacer()
            Spacer()
            tabBarItem(image: "bookmark")
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: tabBarHeight)
        .background(
            Color("tabbar-bg")
        )
    }
}



// MARK: - PREVIEWS
struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
