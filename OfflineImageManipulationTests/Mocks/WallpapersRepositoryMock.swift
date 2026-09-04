//
//  WallpapersRepositoryMock.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 04/09/2026.
//

import Foundation

@testable import OfflineImageManipulation

final class WallpapersRepositoryMock: WallpapersRepositoryProtocol {
    var result: WallpapersRepository.WallpaperResult?
    var error: Error?
    private(set) var fetchCount = 0
    init(result: WallpapersRepository.WallpaperResult? = nil, error: Error? = nil) {
        self.result = result
        self.error = error
    }
    func fetchImages() async throws -> WallpapersRepository.WallpaperResult {
        fetchCount += 1
        if let error { throw error }
        if let result { return result }
        return WallpapersRepository.WallpaperResult(
            items: [
                ImageItemModel(
                    id: 1,
                    title: "Test Wallpaper 1",
                    imageURL: URL(string: "https://picsum.photos/id/88/600/400")!
                )
            ],
            source: .Cache,
            isFromOffline: true
        )
    }
}



