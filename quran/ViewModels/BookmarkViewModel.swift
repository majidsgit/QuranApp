//
//  BookmarkViewModel.swift
//  quran
//
//  Created by developer on 5/13/22.
//

import SwiftUI

extension BookmarkView {
    
    final class ViewModel: ObservableObject {
        
        @Published var SortSelectorValue: String = "surah number"
        
        @Published var toShowItemsBookmarkId: String? = nil
        
        @Published var showingFolderEditPopUpItem: BookmarkFolderModel? = nil
        @Published var showFolderEditPopUp = false
        @Published var showFolderEditTitleValue: String = ""
        
        @Published var showAddNewFolderPopUp = false
        
        @Published var showFolderSortPopUp = false
        
        @Published var showSurahDetailViewFromBookmark = false
        
        @Published var folders: [BookmarkFolderModel] = []
        @Published var bookmarks: [BookmarkItemModel] = []
        
        var fileManager: FileManager? = nil
        
        init() {
            fileManager = FileManager()
            bookmarks = fileManager?.loadBookmarks() ?? []
            bookmarks = fileManager?.sortBookmarks(bookmarks: bookmarks, by: .surah) ?? []
            folders = fileManager?.loadBookmarkFolders() ?? []
            setBookmarkFolderItems()
        }
        
        func setBookmarkFolderItems() {
            for index in 0..<folders.count {
                var items = [BookmarkItemModel]()
                for bookmark in bookmarks {
                    if bookmark.folderId == folders[index].id {
                        items.append(bookmark)
                    }
                }
                folders[index].items = items
            }
        }
        
    }
    
}
