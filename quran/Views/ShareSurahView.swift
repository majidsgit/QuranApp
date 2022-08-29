//
//  ShareSurahView.swift
//  quran
//
//  Created by developer on 5/16/22.
//

import SwiftUI
import UIKit

struct ShareSurahView: View {
    // MARK: - PROPERTIES
    let verse: VerseItemModel?
    let surah: SurahItem?
    
    let textAspect = 1.0
    
    let imageCornerRadius = 16.0 * UIScreen.main.bounds.height / 812.0
    let ayatItemActionButtonHeight = 42.0 * UIScreen.main.bounds.height / 812.0
    let ayatItemHeaderFontSize = 34.0 * UIScreen.main.bounds.height / 812.0
    let imageWidth = 64.0 * UIScreen.main.bounds.width / 374.0
    let bgImageWidth = 750.0 * UIScreen.main.bounds.width / 374.0
    let viewSize = 1000.0
    
    @AppStorage("arabic-font") var arabicFont = "Al Majeed Quranic Font"
    @AppStorage("translate") var showingTranslate: String = "English"
    
    let downloadFontHeadline = 24.0
    let downloadFontSubheadline = 18.0
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            
            Image("share-surah-bg-image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .blur(radius: 2.0)
                .frame(width: bgImageWidth)
                .opacity(0.125)

            VStack(alignment: .center, spacing: 24.0) {

                HStack(alignment: .center, spacing: 16.0) {
                    Image("open-bracket")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(
                            Color("share-surah-text")
                        )
                        .aspectRatio(contentMode: .fit)
                        .frame(width: ayatItemActionButtonHeight)

                    Text(surah?.en_name ?? "")
                        .font(.custom("Poppins-SemiBold", size: ayatItemHeaderFontSize * textAspect))
                        .foregroundColor(Color("share-surah-text"))

                    Circle()
                        .frame(width: 11.0, height: 11.0)
                        .foregroundColor(Color("share-surah-text-dot"))

                    Text("Verse \(verse?.number.description ?? 0.description)")
                        .font(.custom("Poppins-SemiBold", size: ayatItemHeaderFontSize * textAspect))
                        .foregroundColor(Color("share-surah-text"))


                    Image("close-bracket")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(
                            Color("share-surah-text")
                        )
                        .aspectRatio(contentMode: .fit)
                        .frame(width: ayatItemActionButtonHeight)
                }

                Spacer()

                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Text(verse?.text ?? "")
                        .font(.custom(arabicFont, size: 56.0 * textAspect))
                        .fontWeight(.regular)
                        .foregroundColor(Color("share-surah-text"))
                        .multilineTextAlignment(.trailing)
                        .lineLimit(10)
                }
                HStack(alignment: .center, spacing: 0) {
                    Text(showingTranslate == "English" ? verse?.translation_en ?? "" : verse?.translation_id ?? "")
                        .font(.custom("Poppins-Regular", size: 28.0 * textAspect))
                        .foregroundColor(Color("share-surah-text"))
                        .multilineTextAlignment(.leading)
                        .lineLimit(10)
                    Spacer()
                }

                Spacer()

                HStack(alignment: .center, spacing: 14.0) {
                    Image("share-item-app-icon")
                        .resizable()
                        .cornerRadius(imageCornerRadius)
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: imageWidth)
                    VStack(alignment: .leading, spacing: 0) {

                        Text("Quran App")
                            .font(.custom("Poppins-Bold", size: downloadFontHeadline * textAspect))
                            .foregroundColor(Color("share-surah-text"))

                        Text("download from App Store")
                            .font(.custom("Poppins-Regular", size: downloadFontHeadline * textAspect))
                            .foregroundColor(Color("share-surah-text"))
                    }
                }

            }
        }
        .padding(.vertical, 48.0)
        .padding(.horizontal, 36.0)
        .frame(width: viewSize, height: viewSize)
        .background(
            LinearGradient(colors: [
                Color("share-surah-gradient-1"),
                Color("share-surah-gradient-2")
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }
    
    
    // MARK: - FUNCTIONS
    
    
    
    
    
    // MARK: - VIEWS
    
    
    
    
}








// MARK: - PREVIEW
struct ShareSurahView_Previews: PreviewProvider {
    static var previews: some View {
        ShareSurahView(verse: nil, surah: nil)
    }
}
