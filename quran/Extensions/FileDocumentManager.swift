//
//  FileDocumentManager.swift
//  quran
//
//  Created by developer on 5/13/22.
//

import Foundation
import SwiftUI

extension FileManager {
    
    static let saveBookmarkPath = documentsDirectory.appendingPathComponent("savedBookmarks")
    static let saveBookmarkFoldersPath = documentsDirectory.appendingPathComponent("savedBookmarkFolders")
    
    static let inAppPurchasePath = documentsDirectory.appendingPathComponent("inAppPurchase")
    
    enum BookmarkSort {
        case date, surah
    }
    
    func loadBookmarks() -> [BookmarkItemModel] {
        var bookmarks = [BookmarkItemModel]()
        do {
            let data = try Data(contentsOf: FileManager.saveBookmarkPath)
            bookmarks = try JSONDecoder().decode([BookmarkItemModel].self, from: data)
        } catch {
            bookmarks = []
        }
        return bookmarks
    }
    
    func loadBookmarkFolders() -> [BookmarkFolderModel] {
        var bookmarkFolders = [BookmarkFolderModel]()
        do {
            let data = try Data(contentsOf: FileManager.saveBookmarkFoldersPath)
            bookmarkFolders = try JSONDecoder().decode([BookmarkFolderModel].self, from: data)
        } catch {
            bookmarkFolders = []
        }
        return bookmarkFolders
    }
    
    func sortBookmarks(bookmarks: [BookmarkItemModel], by sort: BookmarkSort = .date) -> [BookmarkItemModel] {
        
        if sort == .date {
            return bookmarks.sorted { search1, search2 in
                search1.date < search2.date
            }
        } else {
            return bookmarks.sorted { search1, search2 in
                search1.surah < search2.surah
            }
        }
    }
    
    func saveBookmarks(bookmarks: [BookmarkItemModel]) {
        do {
            let data = try JSONEncoder().encode(bookmarks)
            try data.write(to: FileManager.saveBookmarkPath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func saveBookmarkFolders(folders: [BookmarkFolderModel]) -> [BookmarkFolderModel] {
        
        var currentFolders = [BookmarkFolderModel]()
        for folder in folders {
            let current = BookmarkFolderModel(id: folder.id, title: folder.title, items: nil)
            currentFolders.append(current)
        }
        
        do {
            let data = try JSONEncoder().encode(currentFolders)
            try data.write(to: FileManager.saveBookmarkFoldersPath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
        
        return folders
    }
    
    func addFolder(title: String) -> [BookmarkFolderModel] {
        var folders = loadBookmarkFolders()
        let newFolder = BookmarkFolderModel(title: title)
        if let _ = folders.first(where: { search in
            search.title.uppercased() == title.uppercased()
        }) {
            // folder exists
            return folders
        } else {
            folders.append(newFolder)
            return saveBookmarkFolders(folders: folders)
        }
    }
    
    func addBookmark(to folderId: String, surah: SurahItem, ayah: Int) -> [BookmarkItemModel] {
        
        let newBookmark = BookmarkItemModel(folderId: folderId, surahTitle: surah.en_name, surah: surah.index, ayah: ayah, date: Date())
        
        var bookmarks = loadBookmarks()
        
        if let currentBookmark = bookmarks.first(where: { search in
            search.ayah == newBookmark.ayah && search.surah == newBookmark.surah
        }) {
            bookmarks = removeBookmark(with: currentBookmark.id)
        } else {
            bookmarks.append(newBookmark)
            saveBookmarks(bookmarks: bookmarks)
        }
        
        return bookmarks
    }
    
    func renameFolder(with folderId: String, renameTo: String) -> [BookmarkFolderModel] {
        var folders = loadBookmarkFolders()
        
        guard let toRename = folders.first(where: { search in
            search.id == folderId
        }), let index = folders.firstIndex(where: { search2 in
            search2.id == folderId
        }) else { return folders }
        
        let renamedFolder = BookmarkFolderModel(id: toRename.id, title: renameTo, items: nil)
        
        _ = removeFolder(with: folderId)
        
        folders.insert(renamedFolder, at: index)
        
        return saveBookmarkFolders(folders: folders)
    }
    
    func removeFolder(with folderId: String) -> [BookmarkFolderModel] {
        var folders = loadBookmarkFolders()
        _ = removeBatchBookmark(with: folderId)
        folders.removeAll { search in
            search.id == folderId
        }
        return saveBookmarkFolders(folders: folders)
    }
    
    func removeBookmark(with bookmarkId: String) -> [BookmarkItemModel] {
        
        var bookmarks = loadBookmarks()
        
        bookmarks.removeAll { search in
            search.id == bookmarkId
        }
        saveBookmarks(bookmarks: bookmarks)
        
        return bookmarks
    }
    
    func removeBatchBookmark(with folderId: String) -> [BookmarkItemModel] {
        
        var bookmarks = loadBookmarks()
        
        bookmarks.removeAll { search in
            search.folderId == folderId
        }
        saveBookmarks(bookmarks: bookmarks)
        
        return bookmarks
    }
    
}
