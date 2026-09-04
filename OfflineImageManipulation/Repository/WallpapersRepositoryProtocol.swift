//
//  WallpapersRepositoryProtocol.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 04/09/2026.
//

protocol WallpapersRepositoryProtocol {
    func fetchImages() async throws -> WallpaperResult
}
