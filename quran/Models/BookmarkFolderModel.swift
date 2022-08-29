//
//  BookmarkFolderModel.swift
//  quran
//
//  Created by developer on 5/13/22.
//

import Foundation

struct BookmarkFolderModel: Codable, Identifiable {
    var id = UUID().uuidString
    let title: String
    var items: [BookmarkItemModel]? = nil
}
