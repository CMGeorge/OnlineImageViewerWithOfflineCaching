//
//  WallpapersRepository.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 04/09/2026.
//

import Foundation

struct WallpaperResult {
    let items: [ImageItemModel]
    let source: WallpapersRepository.DataSource
    // true dacă e din cache dar online a eșuat
    let isFromOffline: Bool
}
final class WallpapersRepository: WallpapersRepositoryProtocol{
    enum DataSource: Equatable {
        case Network
        case Cache
    }
    
    private let imageAPI: ImageRetrivalProtocol
    private let cache: WallpaperListCache
    private let network: NetworkMonitorProtocol

    init(imageAPI: ImageRetrivalProtocol = APIService(), cache: WallpaperListCache = WallpaperListCache(), network: NetworkMonitorProtocol) {
        self.imageAPI = imageAPI
        self.cache = cache
        self.network = network
    }
    func fetchImages() async throws -> WallpaperResult {
        if network.connected {
            do {
                let items = try await imageAPI.fetchImages()
                //save the cache
                try cache.saveWallpaperList(items)
                return WallpaperResult(items: items, source: .Network, isFromOffline: false)
            } catch {
                if let cached = try? cache.loadWallpaperList() {
                    return WallpaperResult(items: cached, source: .Cache, isFromOffline: false)
                }
                throw error
            }
        }
        if let cached = try? cache.loadWallpaperList() {
            return WallpaperResult(items: cached, source: .Cache, isFromOffline: false)
        }
        throw APIError.noCacheForOfflineData
    }
}
