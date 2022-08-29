//
//  SurahDetailsViewExtension.swift
//  quran
//
//  Created by developer on 5/13/22.
//

import SwiftUI
import AVKit

extension SurahDetailsView {
    
    class ViewModel: ObservableObject {
        
        @Published var showArabicFontPopup = false
        @Published var showTranslatePopup = false
        
        @Published var currentSurah: AyehItemModel? = nil
        @Published var showBismellah: Bool = true
        
        @Published var showBookmarkPopUp = false
        @Published var toSetBookmarkAye: VerseItemModel? = nil
        @Published var bookmarks = [BookmarkItemModel]()
        @Published var bookmarkFolders = [BookmarkFolderModel]()
        var fileManager: FileManager? = nil
        
        @Published var playingAyeNumber: Int = -1
        @AppStorage("playing-url") var playingURL: Int = 0
        
        @AppStorage("user-last-surah") var userLastSurah: String = ""
        @AppStorage("user-last-ayah") var userLastAyah: Int = -1
        
        @AppStorage("arabic-fontsize") var arabicFontSize = 34.0
        @AppStorage("arabic-font") var arabicFont = "Al Majeed Quranic Font"
        @AppStorage("translate-fontsize") var translateFontSize = 22.0
        @AppStorage("translate") var showingTranslate: String = "English"
        
        var player: MyAudioPlayer? = nil
        
        let playingURLS = [
            "https://www.everyayah.com/data/AbdulSamad_64kbps_QuranExplorer.Com/",
        ]
        
        init() {
            fileManager = FileManager()
            bookmarks = fileManager?.loadBookmarks() ?? []
            bookmarkFolders = fileManager?.loadBookmarkFolders() ?? []
            setBookmarkFolderItems()
        }
        
        func loadDetails(of surah: SurahItem?) {
            showBismellah = false
            currentSurah = loadOneSurah(index: surah?.index ?? -1)
            if let currentSurah = currentSurah {
                if let extra = currentSurah.extra {
                    if extra.contains("no-bism") {
                        showBismellah = false
                    }
                } else {
                    showBismellah = true
                }
            }
        }
        
        func setBookmarkFolderItems() {
            for index in 0..<bookmarkFolders.count {
                var items = [BookmarkItemModel]()
                for bookmark in bookmarks {
                    if bookmark.folderId == bookmarkFolders[index].id {
                        items.append(bookmark)
                    }
                }
                bookmarkFolders[index].items = items
            }
        }
        
        

        
        private func numberGenerator(number: Int) -> String {
            if number < 10 {
                return "00\(number)"
            } else if number >= 10 && number <= 99 {
                return "0\(number)"
            } else {
                return "\(number)"
            }
        }
        
        func createPlayList(first: Int) -> [String] {
            
            guard let currentSurah = currentSurah else { return [] }

            
            var playlist = [String]()
            for index in first...currentSurah.total_verses {
                
                let current = playingURLS[playingURL] + "\(numberGenerator(number: currentSurah.number))\(numberGenerator(number: index)).mp3"
                
                playlist.append(current)
            }
            
            return playlist
        }
        
        func play(aye: Int) {
            guard player != nil else {
                let playlist = createPlayList(first: aye)
                
                player = MyAudioPlayer(playlist: playlist) { [weak self] index in
                    DispatchQueue.main.async {
                        self?.playingAyeNumber = index + aye - 1
                    }
                }
                player?.play()
                
                return
            }
            
            player?.destroy()
            self.playingAyeNumber = -1
            self.player = nil
            
        }
        
        func playButtonTapped(aye: Int) {
            playingAyeNumber = aye
            play(aye: aye)
        }
        
        func pauseButtonTapped(aye: Int) {
            playingAyeNumber = -1
            self.player = nil
            return
        }
        
        func changeArabicFont(with font: String) {
            withAnimation(.default) {
                arabicFont = font
            }
        }
        
        func changeTranslateLanguage(with language: String) {
            withAnimation(.spring()) {
                showingTranslate = language
            }
        }
        
        
        func shareSheet(image: UIImage) {
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
        
    }
    
}
