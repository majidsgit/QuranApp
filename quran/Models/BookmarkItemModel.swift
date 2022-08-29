//
//  BookmarkItemModel.swift
//  quran
//
//  Created by developer on 5/13/22.
//

import Foundation

struct BookmarkItemModel: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    let folderId: String
    let surahTitle: String
    let surah: Int
    let ayah: Int
    let date: Date
}
