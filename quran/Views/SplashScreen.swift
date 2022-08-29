//
//  SplashScreen.swift
//  quran
//
//  Created by developer on 5/13/22.
//

import SwiftUI

struct SplashScreen: View {
    
    // MARK: - PROPERTIES
    let buttonSize = CGSize(width: 185.0, height: 60.0 * UIScreen.main.bounds.height / 812)
    let imageSize = CGSize(width: 314.0, height: 450.0)
    
    let textAspect = UIScreen.main.bounds.size.height / 812.0
    
    @State private var showHome = false
    
    
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                
                Text("Quran App")
                    .font(.custom("Poppins-Bold", size: 28 * textAspect))
                    .foregroundColor(Color("splash-headline-text"))
                
                Text("Learn Quran and\nRecite once everyday")
                    .font(.custom("Poppins-Regular", size: 18 * textAspect))
                    .foregroundColor(Color("splash-subheadline-text"))
                    .multilineTextAlignment(.center)
                    .padding(.top, 16.0 * textAspect)
                
                ZStack(alignment: .bottom) {
                    Image("splash-card-image")
                        .aspectRatio(contentMode: .fit)
                        .frame(height: imageSize.height)
                    
                    NavigationLink(isActive: $showHome) {
                        TabsView()
                            .navigationBarBackButtonHidden(true)
                            .navigationBarHidden(true)
                    } label: {
                        EmptyView()
                    }
                    
                    buttonView()
                        .padding(.horizontal, 64.5)
                        .offset(y: buttonSize.height / 2.0)
                        .onTapGesture {
                            showHome.toggle()
                        }
                }
                .padding(.top, 49 * textAspect)
            }
            .background(
                Color("screen-bg")
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    // MARK: - VIEWS
    @ViewBuilder
    func buttonView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: buttonSize.height / 2.0, style: .continuous)
                .frame(width: buttonSize.width, height: buttonSize.height)
                .foregroundColor(Color("splash-button-bg"))
            
            Text("Get Started")
                .font(.custom("Poppins-SemiBold", size: 18 * buttonSize.height / 60))
                .foregroundColor(Color("splash-button-text"))
        }
    }
}




// MARK: - PREVIEWS
struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
