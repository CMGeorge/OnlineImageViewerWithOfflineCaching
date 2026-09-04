//
//  WallpaperListCache.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 04/09/2026.
//

import Foundation

final class WallpaperListCache: Sendable {
    private let fileURL: URL
    init(fileURL: URL? = nil) {
        if let fileURL {
            self.fileURL = fileURL
        } else {
            let folder = FileManager.default.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            )[0]
            try? FileManager.default.createDirectory(
                at: folder,
                withIntermediateDirectories: true
            )
            self.fileURL = folder.appendingPathComponent("wallpaper_list.json")
        }
    }
    func loadWallpaperList() throws -> [ImageItemModel] {
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([ImageItemModel].self, from: data)
    }
    func saveWallpaperList(_ list: [ImageItemModel]) throws {
        let data = try JSONEncoder().encode(list)
        try data.write(to: fileURL, options: .atomic)
        print("List cache saved \(list.count) items to \(fileURL.path)")

    }
}
