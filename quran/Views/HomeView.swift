//
//  HomeView.swift
//  quran
//
//  Created by developer on 5/13/22.
//

import SwiftUI

struct HomeView: View {
    // MARK: - PROPERTIES
    let textAspect = 1.0
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    
    @StateObject private var viewModel = ViewModel()
    
    @State private var showPurchaseAdView = false
    
    let popupViewRound = 20.0 * UIScreen.main.bounds.height / 812.0
    let popupBottomSpacing = 80.0 * UIScreen.main.bounds.height / 812.0 + UIDevice.bottomIndicatorHeight
    
    let buttonSize = CGSize(width: 100.0 * UIScreen.main.bounds.width / 374.0, height: 45.0 * UIScreen.main.bounds.height / 812)
    
    
    let headerYMargin = UIDevice.hasNotch ? 15.0 : 20.0 * UIScreen.main.bounds.height / 812.0
    let headerButtonHeight = 24.0 * UIScreen.main.bounds.height / 812.0
    
    let lastReadCardWidth = 326.0 * UIScreen.main.bounds.width / 374.0
    let lastReadCardHeight = 131.0 * UIScreen.main.bounds.height / 812.0
    let lastReadRounded = 10.0 * UIScreen.main.bounds.height / 812.0
    let lastReadReadmeHeight = 20.0 * UIScreen.main.bounds.height / 812.0
    let lastReadContentMargin = 20.0 * UIScreen.main.bounds.width / 374.0
    
    let contentTabs = ["Verse", "Juz", "Page"]
    let contentTabsHeight = 52.0 * UIScreen.main.bounds.height / 812.0
    let contentEachTabWidth = UIScreen.main.bounds.width - 48.0
    @Namespace var namespace
    
    let contentsItemHeight = 70.0 * UIScreen.main.bounds.height / 812.0
    let contentsItemIconHeight = 40.0 * UIScreen.main.bounds.height / 812.0
    let contentsItemDescriptionDotHeight = 4.0 * UIScreen.main.bounds.height / 812.0
    
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24.0) {
                HeaderSectionView(content: "Quran App", leftItem: "menu") {
                    
                    // on dismiss!
                    print(" - HomeView dismissed!")
                }

                TitleView()
                if viewModel.userLastSurah != "" && viewModel.userLastAyah != -1 {
                    if let surah = surahItemExample.first { search in
                        search.en_name == viewModel.userLastSurah
                    } {
                        NavigationLink(destination: {
                            SurahDetailsView(surah: surah, aye: viewModel.userLastAyah)
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                        }, label: {
                            LastReadCardView()
                        })
                        .buttonStyle(FlatLinkStyle())
                    }
                }
                ContentTabsView()
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    ContentsView()
                }
            }
        }
        .padding(.horizontal, 24.0)
        .background(
            Color("screen-bg")
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
        )
        .popup(isPresented: $viewModel.showUserProfilePopUpView, type: .toast, position: .bottom, closeOnTap: false, closeOnTapOutside: true) {
            UserProfilePopUpView()
        }
        .onDisappear {
            // view disappeared
            print(" > HomeView disappeared!")
        }
    }
    
    
    
    // MARK: - VIEWS
    
    
    
    
    
    
    
    
    // MARK: - UserProfilePopUpView
    func UserProfilePopUpView() -> some View {
        VStack(alignment: .center, spacing: 16.0) {
            HStack(alignment: .center) {
                Text("Change Profile Name")
                    .font(.custom("Poppins-SemiBold", size: 18.0 * textAspect))
                    .foregroundColor(Color("popup-text"))
                
                Spacer()
            }
            
            Rectangle()
                .frame(height: 1.0)
                .foregroundColor(Color("popup-divider"))
                .padding(.vertical, 8.0)
            
            TextField(viewModel.userProfileName, text: $viewModel.userProfileNameEditing)
                .lineLimit(1)
                .disableAutocorrection(true)
                .font(.custom("Poppins-Bold", size: 18.0 * textAspect))
                .foregroundColor(Color("popup-textfield-text"))
                .frame(height: 50.0)
                .padding(.horizontal, 24.0)
                .background(Color("popup-textfield-bg"))
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                
            ZStack {
                RoundedRectangle(cornerRadius: buttonSize.height / 2.0, style: .continuous)
                    .frame(width: buttonSize.width, height: buttonSize.height)
                    .foregroundColor(Color("popup-normal-button-bg"))
                
                Text("Change")
                    .font(.custom("Poppins-SemiBold", size: 18 * buttonSize.height / 60))
                    .foregroundColor(Color("popup-button-text"))
            }
            .padding(.vertical, 8.0)
            .onTapGesture {
                withAnimation(.default) {
                    if viewModel.userProfileNameEditing != "" {
                        viewModel.userProfileName = viewModel.userProfileNameEditing
                    }
                }
                viewModel.showUserProfilePopUpView.toggle()
            }
        }
        .padding(.top, 24.0)
        .padding(.bottom, keyboardHeightHelper.keyboardHeight > 0 ? keyboardHeightHelper.keyboardHeight + UIDevice.bottomIndicatorHeight : popupBottomSpacing)
        .padding(.horizontal, 24.0)
        .frame(width: UIScreen.main.bounds.width - popupViewRound)
        .background(Color("popup-bg"))
        .cornerRadius(popupViewRound)
        .shadow(color: Color("popup-shadow"), radius: 20, x: 10, y: 10)
    }
    
    
    
    
    
    
    
    // MARK: - TitleView
    @ViewBuilder
    func TitleView() -> some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Text("Asslamualaikum")
                .font(.custom("Poppins-Medium", size: 18 * textAspect))
                .foregroundColor(Color("usertitle-subheadline-text"))
            
            Text(viewModel.userProfileName)
                .font(.custom("Poppins-SemiBold", size: 24 * textAspect))
                .foregroundColor(Color("usertitle-headline-text"))
        }
        .onTapGesture {
            viewModel.showUserProfilePopUpView.toggle()
        }
    }
    
    
    
    
    
    
    
    // MARK: - LastReadCardView
    @ViewBuilder
    func LastReadCardContentView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 8) {
                Image("last-read-card-readme")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color("last-read-card-text"))
                    .aspectRatio(contentMode: .fit)
                    .frame(height: lastReadReadmeHeight)
                
                Text("Last Read")
                    .font(.custom("Poppins-Medium", size: 14 * textAspect))
                    .foregroundColor(Color("last-read-card-text"))
            }
            
            Text(viewModel.userLastSurah)
                .font(.custom("Poppins-SemiBold", size: 18 * textAspect))
                .foregroundColor(Color("last-read-card-text"))
                .padding(.top, lastReadContentMargin)
            
            Text("Ayah No: \(viewModel.userLastAyah.description)")
                .font(.custom("Poppins-Regular", size: 14 * textAspect))
                .foregroundColor(Color("last-read-card-text"))
                .padding(.top, lastReadContentMargin / 5.0)
        }
        .padding(.all, lastReadContentMargin)
    }
    @ViewBuilder
    func LastReadCardView() -> some View {
        ZStack(alignment: .leading) {
            Image("last-read-card-image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: lastReadCardWidth)
            
            LastReadCardContentView()
        }
        .background(
            LinearGradient(colors: [
                Color("last-read-card-gradient-1"),
                Color("last-read-card-gradient-2")
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .cornerRadius(lastReadRounded)
        )
    }
    
    
    
    
    
    
    
    // MARK: - ContentTabsView
    @ViewBuilder
    func ContentTabsItemView(item: String) -> some View {
        ZStack(alignment: .center) {
            Text(item)
                .font(.custom(viewModel.selectedContentTab == item ?  "Poppins-SemiBold" : "Poppins-Medium" , size: 16 * textAspect))
                .foregroundColor(
                    viewModel.selectedContentTab == item ?
                        Color("content-tabs-selected-tab-text") :
                        Color("content-tabs-not-selected-text")
                )
            
            if(viewModel.selectedContentTab == item) {
                ZStack(alignment: .bottom) {
                    VStack (alignment: .center, spacing: 0) {
                        Spacer()
                        Rectangle()
                            .frame(height: 3.0)
                            .foregroundColor(Color("content-tabs-indicator"))
                    }
                }
                .matchedGeometryEffect(id: "item", in: namespace)
            }
            
        }
        .onTapGesture {
            withAnimation(.interpolatingSpring(stiffness: 75, damping: 10)) {
                viewModel.selectedContentTab = item
            }
        }
        .frame(width: contentEachTabWidth / CGFloat(contentTabs.count), height: contentTabsHeight)
    }
    @ViewBuilder
    func ContentTabsView() -> some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(contentTabs, id:\.self) { item in
                ContentTabsItemView(item: item)
            }
        }
    }
    
    
    
    
    
    // MARK: - ContentsView
    @ViewBuilder
    func ContentsItemView(item: SurahItem) -> some View {
        ZStack(alignment: .leading) {
            
            HStack(alignment: .center, spacing: 16.0) {
                
                ZStack(alignment: .center) {
                    Image("content-item-index")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color("content-item-index-icon"))
                        .aspectRatio(contentMode: .fit)
                        .frame(height: contentsItemIconHeight)
                    
                    Text("\(item.index.description)")
                        .font(.custom("Poppins-Medium", size: 14 * textAspect))
                        .foregroundColor(Color("content-item-surah-index-text"))
                }
                
                VStack(alignment: .leading, spacing: 4.0) {
                    
                    Text(item.en_name)
                        .font(.custom("Poppins-Medium", size: 16 * textAspect))
                        .foregroundColor(Color("content-item-surah-title-text"))
                    
                    HStack(alignment: .center, spacing: 5.0) {
                        
                        Text(item.type)
                            .textCase(.uppercase)
                            .font(.custom("Poppins-Medium", size: 12 * textAspect))
                            .foregroundColor(Color("content-item-surah-description-text"))
                        
                        RoundedRectangle(cornerRadius: 2.0, style: .continuous)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame( height: contentsItemDescriptionDotHeight)
                            .foregroundColor(Color("content-item-surah-description-dot"))
                        
                        switch viewModel.selectedContentTab {
                        case "Juz":
                            Text("juz \(item.juz.description)")
                                .textCase(.uppercase)
                                .font(.custom("Poppins-Medium", size: 12 * textAspect))
                                .foregroundColor(Color("content-item-surah-description-text"))
                        case "Page":
                            Text("page \(item.page.description)")
                                .textCase(.uppercase)
                                .font(.custom("Poppins-Medium", size: 12 * textAspect))
                                .foregroundColor(Color("content-item-surah-description-text"))
                        default:
                            Text("\(item.aya_count.description) versus")
                                .textCase(.uppercase)
                                .font(.custom("Poppins-Medium", size: 12 * textAspect))
                                .foregroundColor(Color("content-item-surah-description-text"))
                        }
                        
                        
                    }
                }
                
                Spacer()
                
                Text(stringToUnicodeCharacter(string: item.icon))
                    .font(.custom("icomoon", size: 28.0 * textAspect))
                    .foregroundColor(Color("content-item-surah-icon-text"))
            }
            
            
            ZStack(alignment: .bottom) {
                VStack(alignment: .center) {
                    Spacer()
                    Rectangle()
                        .frame(height: 1.0)
                        .foregroundColor(Color("content-item-divider"))
                }
            }
            .opacity(surahItemExample.last?.index == item.index ? 0.0 : 1.0)
        }
        .frame(height: contentsItemHeight)
    }
    
    @ViewBuilder
    func ContentsView() -> some View {
        LazyVStack(alignment: .center, spacing: 0) {
            ForEach(surahItemExample, id:\.self) { item in
                NavigationLink(destination: {
                    SurahDetailsView(surah: item)
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }, label: {
                    ContentsItemView(item: item)
                })
            }
            Spacer(minLength: contentsItemHeight * 1.5)
        }
    }
    
}




// MARK: - PREVIEWS
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
