//
//  SurahDetailsView.swift
//  quran
//
//  Created by developer on 5/13/22.
//

import SwiftUI

struct SurahDetailsView: View {
    // MARK: - PROPERTIES
    let textAspect = 1.0
    
    @StateObject private var viewModel = ViewModel()
    
    let detailCardWidth = 327.0 * UIScreen.main.bounds.width / 374.0
    let detailCardHeight = 257.0 * UIScreen.main.bounds.height / 812.0
    let detailRounded = 20.0 * UIScreen.main.bounds.height / 812.0
    
    let detailDotHeight = 4.0 * UIScreen.main.bounds.height / 812.0
    
    let detailBesmHeight = 48.0 * UIScreen.main.bounds.height / 812.0
    
    let ayatSectionHeaderBGHeight = 47.0 * UIScreen.main.bounds.height / 812.0
    let ayatSectionHeaderBGRound = 10.0 * UIScreen.main.bounds.height / 812.0
    let ayatItemActionButtonHeight = 24.0 * UIScreen.main.bounds.height / 812.0
    let ayatItemIndexDotBGHeight = 27.0 * UIScreen.main.bounds.height / 812.0
    
    let popupViewRound = 20.0 * UIScreen.main.bounds.height / 812.0
    let popupPickerHeight = 50.0 * UIScreen.main.bounds.height / 812.0
    
    let bookmarkItemFolderHeight = 24.0 * UIScreen.main.bounds.height / 812.0
    let bookmarkItemMoreHeight = 24.0 * UIScreen.main.bounds.height / 812.0
    
    let BookMarkItemHeight = 46.0 * UIScreen.main.bounds.height / 812.0
    
    let FolderItemIndexHeight = 40.0 * UIScreen.main.bounds.height / 812.0
    let FolderItemBookmarkHeight = 32.0 * UIScreen.main.bounds.height / 812.0
    
    let fontStyleItemHeight = 52.0 * UIScreen.main.bounds.height / 812.0
    let fontStyleItemWidth = UIScreen.main.bounds.width - 48.0
    @Namespace var namespace
    
    let fonts = ["Al Qalam Quran", "Al Majeed Quranic Font"]
    let languages = ["English", "Indonesian"]
    
    var surah: SurahItem?
    var aye: Int? = -1
    @EnvironmentObject var storeManager: StoreManager
    
    init(surah: SurahItem?, aye: Int = -1) {
        self.surah = surah
        self.aye = aye
    }
    
    
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24.0) {
                HeaderSectionView(content: surah?.en_name ?? "Surah", leftItem: "back") {
                    
                    // view dismissed
                    viewModel.player?.destroy()
                }
                DetailCardView()
                
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollViewReader { proxy in
                        AyatView()
                        Spacer(minLength: ayatSectionHeaderBGHeight)
                            .onChange(of: viewModel.playingAyeNumber) { newValue in
                                
                                withAnimation {
                                    proxy.scrollTo(newValue, anchor: .top)
                                }
                            }
                    }
                }
                
            }
        }
        .padding(.horizontal, 24.0)
        .background(
            Color("screen-bg")
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .edgesIgnoringSafeArea(.all)
        )
        .popup(isPresented: $viewModel.showArabicFontPopup, type: .toast, position: .bottom, closeOnTap: false, closeOnTapOutside: true) {
            ArabicFontPopUpView()
        }
        
        .popup(isPresented: $viewModel.showTranslatePopup, type: .toast, position: .bottom, closeOnTap: false, closeOnTapOutside: true) {
            TranslatePopUpView()
        }
        
        .popup(isPresented: $viewModel.showBookmarkPopUp, type: .toast, position: .bottom, closeOnTap: false, closeOnTapOutside: true) {
            BookmarkPopUpView()
        }
        
        .onAppear {
            viewModel.loadDetails(of: surah)
            if let aye = aye {
                viewModel.playingAyeNumber = aye
            }
        }
        
        .onChange(of: viewModel.playingAyeNumber) { newValue in
            guard let surah = surah else { return }
            guard newValue > 0 else { return }
            viewModel.userLastAyah = newValue
            viewModel.userLastSurah = surah.en_name
        }
        
    }
    
    
    
    // MARK: - VIEWS
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: BookmarkPopUpView
    func BookmarkFolderItemView(folder: BookmarkFolderModel) -> some View {
        HStack(alignment: .center, spacing: 16.0) {
            
            VStack(alignment: .leading) {
                Image("bookmark-item-folder-image")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color("popup-bookmark-folder"))
                    .aspectRatio(contentMode: .fit)
                    .frame(height: bookmarkItemFolderHeight)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4.0) {
                Text(folder.title)
                    .font(.custom("Poppins-Medium", size: 16.0 * textAspect))
                    .foregroundColor(Color("popup-bookmark-title-text"))
                
                Text("\(folder.items?.count.description ?? 0.description) items")
                    .font(.custom("Poppins-Medium", size: 12.0 * textAspect))
                    .foregroundColor(Color("popup-bookmark-subtitle-text"))
            }
            
        }
        .frame(height: BookMarkItemHeight)
        .onTapGesture {
            viewModel.bookmarks =  viewModel.fileManager?.addBookmark(to: folder.id, surah: surah!, ayah: viewModel.toSetBookmarkAye!.number) ?? []
            viewModel.setBookmarkFolderItems()
        }
    }
    
    func BookmarkPopUpView() -> some View {
        VStack(alignment: .leading, spacing: 16.0) {
            HStack(alignment: .center) {
                Text("Set Bookmark")
                    .font(.custom("Poppins-SemiBold", size: 18.0 * textAspect))
                    .foregroundColor(Color("popup-text"))
                
                Spacer()
                
                Text("\(viewModel.bookmarks.count.description) bookmarks set")
                    .font(.custom("Poppins-Regular", size: 16.0 * textAspect))
                    .foregroundColor(Color("popup-text"))
                    .multilineTextAlignment(.trailing)
            }
            
            Rectangle()
                .frame(height: 1.0)
                .foregroundColor(Color("popup-divider"))
                .padding(.vertical, 8.0)
            
            
        
            VStack(alignment: .leading, spacing: 16.0) {
                ForEach(viewModel.bookmarkFolders) { folder in
                    BookmarkFolderItemView(folder: folder)
                }
            }
                
            
            
        }
        .padding(.top, 24.0)
        .padding(.bottom, 36.0)
        .padding(.horizontal, 24.0)
        .frame(width: UIScreen.main.bounds.width - popupViewRound)
        .background(Color("popup-bg"))
        .cornerRadius(popupViewRound)
        .shadow(color: Color("popup-shadow"), radius: 20, x: 10, y: 10)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - ArabicFontPopUpView
    @ViewBuilder
    func ArabicFontPopUpView() -> some View {
        VStack(alignment: .leading, spacing: 16.0) {
            HStack(alignment: .center) {
                Text("Arabic font size")
                    .font(.custom("Poppins-SemiBold", size: 18.0 * textAspect))
                    .foregroundColor(Color("popup-text"))
                
                Spacer()
                
                Text("\(Int(viewModel.arabicFontSize).description) Pt")
                    .font(.custom("Poppins-Regular", size: 16.0 * textAspect))
                    .foregroundColor(Color("popup-text"))
                    .multilineTextAlignment(.leading)
            }
            
            if #available(iOS 15.0, *) {
                Slider(value: $viewModel.arabicFontSize, in: 28...42, step: 1)
                    .tint(Color("popup-slider"))
            } else {
                Slider(value: $viewModel.arabicFontSize, in: 28...42, step: 1)
                    .accentColor(Color("popup-slider"))
            }
            
            Rectangle()
                .frame(height: 1.0)
                .foregroundColor(Color("popup-divider"))
                .padding(.vertical, 8.0)
            
            HStack(alignment: .center) {
                Text("Arabic font")
                    .font(.custom("Poppins-SemiBold", size: 18.0 * textAspect))
                    .foregroundColor(Color("popup-text"))
                Spacer()
            }
            
            FontStyleSelectorView()
            
        }
        .padding(.top, 24.0)
        .padding(.bottom, 36.0)
        .padding(.horizontal, 24.0)
        .frame(width: UIScreen.main.bounds.width - popupViewRound)
        .background(Color("popup-bg"))
        .cornerRadius(popupViewRound)
        .shadow(color: Color("popup-shadow"), radius: 20, x: 10, y: 10)
    }
    
    
    
    
    
    
    // MARK: - FontStyleSelectorView
    @ViewBuilder
    func FontStyleItemView(font: String) -> some View {
        ZStack(alignment: .center) {
            Text("الْحَمْدُ لِلَّهِ رَبِّ الْعٰلَمِينَ")
                .font(.custom(font , size: 26.0 * textAspect))
                .fontWeight(.regular)
                .foregroundColor(
                    viewModel.arabicFont == font ?
                        Color("popup-tab-selected-text") :
                        Color("popup-tab-not-selected-text")
                )
            
            if(viewModel.arabicFont == font) {
                ZStack(alignment: .bottom) {
                    VStack (alignment: .center, spacing: 0) {
                        Spacer()
                        Rectangle()
                            .frame(height: 3.0)
                            .foregroundColor(Color("popup-tab-indicator"))
                    }
                }
                .matchedGeometryEffect(id: "font-item", in: namespace)
            }
            
        }
        .onTapGesture {
            viewModel.changeArabicFont(with: font)
        }
        .frame(width: fontStyleItemWidth / CGFloat(fonts.count), height: fontStyleItemHeight)
    }
    
    @ViewBuilder
    func FontStyleSelectorView() -> some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(fonts, id:\.self) { font in
                FontStyleItemView(font: font)
            }
        }
    }
    
    
    
    
    
    
    // MARK: - TranslatePopUpView
    @ViewBuilder
    func TranslatePopUpView() -> some View {
        VStack(alignment: .leading, spacing: 16.0) {
            HStack(alignment: .center) {
                Text("Translate font size")
                    .font(.custom("Poppins-SemiBold", size: 18.0 * textAspect))
                    .foregroundColor(Color("popup-text"))
                
                Spacer()
                
                Text("\(Int(viewModel.translateFontSize).description) Pt")
                    .font(.custom("Poppins-Regular", size: 16.0 * textAspect))
                    .foregroundColor(Color("popup-text"))
                    .multilineTextAlignment(.leading)
                
            }
            
            if #available(iOS 15.0, *) {
                Slider(value: $viewModel.translateFontSize, in: 18...28, step: 1)
                    .tint(Color("popup-slider"))
            } else {
                Slider(value: $viewModel.translateFontSize, in: 18...28, step: 1)
                    .accentColor(Color("popup-slider"))
            }
            
            
            Rectangle()
                .frame(height: 1.0)
                .foregroundColor(Color("popup-divider"))
                .padding(.vertical, 8.0)
            
            
            HStack(alignment: .center) {
                Text("Translate language")
                    .font(.custom("Poppins-SemiBold", size: 18.0 * textAspect))
                    .foregroundColor(Color("popup-text"))
                
                Spacer()
            }
            
            
            TranslateSelectorView()
            
        }
        .padding(.top, 24.0)
        .padding(.bottom, 36.0)
        .padding(.horizontal, 24.0)
        .frame(width: UIScreen.main.bounds.width - popupViewRound)
        .background(Color("popup-bg"))
        .cornerRadius(popupViewRound)
        .shadow(color: Color("popup-shadow"), radius: 20, x: 10, y: 10)
    }
    
    
    
    
    
    
    
    
    // MARK: - TranslateSelectorView
    @ViewBuilder
    func TranslateSelectorItemView(language: String) -> some View {
        ZStack(alignment: .center) {
            Text(language)
                .font(.custom("Poppins-SemiBold", size: 18.0 * textAspect))
                .foregroundColor(
                    viewModel.showingTranslate == language ?
                        Color("popup-tab-selected-text") :
                        Color("popup-tab-not-selected-text")
                )
            
            if(viewModel.showingTranslate == language) {
                ZStack(alignment: .bottom) {
                    VStack (alignment: .center, spacing: 0) {
                        Spacer()
                        Rectangle()
                            .frame(height: 3.0)
                            .foregroundColor(Color("popup-tab-indicator"))
                    }
                }
                .matchedGeometryEffect(id: "language-item", in: namespace)
            }
            
        }
        .onTapGesture {
            viewModel.changeTranslateLanguage(with: language)
        }
        .frame(width: fontStyleItemWidth / CGFloat(fonts.count), height: fontStyleItemHeight)
    }
    
    @ViewBuilder
    func TranslateSelectorView() -> some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(languages, id:\.self) { language in
                TranslateSelectorItemView(language: language)
            }
        }
    }
    
    
    
    
    
    // MARK: - DetailCardView
    @ViewBuilder
    func DetailCardContentView() -> some View {
        VStack(alignment: .center, spacing: 16.0) {
            
            Text(surah?.en_name ?? "Surah")
                .font(.custom("Poppins-Medium", size: 26 * textAspect))
                .foregroundColor(Color("surah-details-section-text"))
            
            Text(surah?.en_meaning ?? "Meaning")
                .font(.custom("Poppins-Medium", size: 16 * textAspect))
                .foregroundColor(Color("surah-details-section-text"))
            
            Rectangle()
                .frame(width: detailCardWidth / 1.65, height: 1.0)
                .foregroundColor(Color("surah-details-section-divider"))
            
            HStack(alignment: .center, spacing: 5.0) {
                
                Text(surah?.type ?? "type")
                    .textCase(.uppercase)
                    .font(.custom("Poppins-Medium", size: 14 * textAspect))
                    .foregroundColor(Color("surah-details-section-text"))
                
                RoundedRectangle(cornerRadius: 2.0, style: .continuous)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame( height: detailDotHeight)
                    .foregroundColor(Color("surah-details-section-dot"))
                
                Text("\(surah?.aya_count.description ?? "-1") versus")
                    .textCase(.uppercase)
                    .font(.custom("Poppins-Medium", size: 14 * textAspect))
                    .foregroundColor(Color("surah-details-section-text"))
                
                
            }
            
            Image("besm")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color("surah-details-section-text"))
                .aspectRatio(contentMode: .fit)
                .frame(height: detailBesmHeight)
                .padding(.vertical, 16.0)
                .opacity(viewModel.showBismellah ? 1.0 : 0.0)
            
        }
    }
    
    @ViewBuilder
    func DetailCardView() -> some View {
        
        ZStack(alignment: .center) {
            Image("surah-details-section-image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: detailCardWidth)
                .blendMode(.softLight)
            
            DetailCardContentView()
        }
        .background(
            LinearGradient(colors: [
                Color("last-read-card-gradient-1"),
                Color("last-read-card-gradient-2")
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .cornerRadius(detailRounded)
        )
    }
    
    
    
    
    
    // MARK: - AyatView
    @ViewBuilder
    func AyatItemActionButtonView(name: String) -> some View {
        Image(name)
            .resizable()
            .renderingMode(.template)
            .foregroundColor(Color("ayat-section-header-action-button"))
            .aspectRatio(contentMode: .fit)
            .frame(width: ayatItemActionButtonHeight)
    }
    
    @ViewBuilder
    func AyatItemView(aye: VerseItemModel) -> some View {
        VStack(alignment: .leading, spacing: 24.0) {
            ZStack {
                RoundedRectangle(cornerRadius: ayatSectionHeaderBGRound, style: .continuous)
                    .frame(height: ayatSectionHeaderBGHeight)
                    .foregroundColor(Color("ayat-section-header-bg"))
                HStack(alignment: .center, spacing: 16.0) {
                    ZStack {
                        RoundedRectangle(cornerRadius: ayatItemIndexDotBGHeight / 2, style: .continuous)
                            .frame(width: ayatItemIndexDotBGHeight, height: ayatItemIndexDotBGHeight)
                            .foregroundColor(Color("ayat-section-header-index-bg-dot"))
                        Text("\(aye.number.description)")
                            .font(.custom("Poppins-Medium", size: 14.0 * textAspect))
                            .foregroundColor(Color("ayat-section-header-text"))
                    }
                    if let _ = aye.extra {
                        AyatItemActionButtonView(name: "ayat-section-header-sajde-image")
                            .onTapGesture {
                                // sajdeh
                            }
                    }
                    
                    Spacer()
                    
                    AyatItemActionButtonView(name: "ayat-section-header-share-image")
                        .onTapGesture {
                            guard let shareAyeSnapShot = ShareSurahView(verse: aye, surah: surah).snapshot() else { return }
                            viewModel.shareSheet(image: shareAyeSnapShot)
                        }
                    AyatItemActionButtonView(name: (viewModel.playingAyeNumber == aye.number && viewModel.player != nil) ? "ayat-section-header-pause-image-active" : "ayat-section-header-play-image")
                        .onTapGesture {
                            viewModel.play(aye: aye.number)
                        }
                    if let currentBookmark = viewModel.bookmarks.first(where: { search in
                        search.ayah == aye.number && search.surah == surah?.index
                    }) {
                        AyatItemActionButtonView(name: "ayat-section-header-bookmark-image-active")
                            .onTapGesture {
                                // remove bookmark
                                viewModel.bookmarks =  viewModel.fileManager?.removeBookmark(with: currentBookmark.id) ?? []
                            }
                    } else {
                        AyatItemActionButtonView(name: "ayat-section-header-bookmark-image")
                            .onTapGesture {
                                // show bookmark popup
                                viewModel.toSetBookmarkAye = aye
                                viewModel.showBookmarkPopUp.toggle()
                            }
                    }
                }
                .padding(.horizontal, 13.0)
            }
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                Text(aye.text)
                    .font(.custom(viewModel.arabicFont, size: viewModel.arabicFontSize * textAspect))
                    .fontWeight(.regular)
                    .foregroundColor(Color("ayat-arabic-text"))
                    .multilineTextAlignment(.trailing)
                    .animation(nil)
                    .onTapGesture {
                        viewModel.showTranslatePopup = false
                        viewModel.showArabicFontPopup.toggle()
                    }
            }
            
            Text(viewModel.showingTranslate == "English" ? aye.translation_en : aye.translation_id)
                .font(.custom("Poppins-Regular", size: viewModel.translateFontSize * textAspect))
                .foregroundColor(Color("ayat-translate-text"))
                .animation(nil)
                .onTapGesture {
                    viewModel.showArabicFontPopup = false
                    viewModel.showTranslatePopup.toggle()
                }
                
            
            if (aye.number != surah?.aya_count) {
                Rectangle()
                    .frame(height: 1.0)
                    .foregroundColor(Color("ayat-divider"))
            }
        }
    }
    
    @ViewBuilder
    func AyatView() -> some View {
        if let currentSurah = viewModel.currentSurah {
            LazyVStack(alignment: .center, spacing: 24.0) {
                ForEach(currentSurah.verses, id: \.self) { verse in
                    AyatItemView(aye: verse)
                        .id(verse.number)
                }
            }
        }
    }
}

// MARK: - PREVIEWS
struct SurahDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SurahDetailsView(surah: nil)
    }
}
