//
//  WallpapersRepositoryTests.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 04/09/2026.
//

import XCTest

@testable import OfflineImageManipulation

final class WallpapersRepositoryTests: XCTestCase {
    private var fileURL: URL!
    override func setUp() {
        fileURL = tempListURL()
    }
    override func tearDown() {
        try? FileManager.default.removeItem(at: fileURL)
    }
    //test agains real api
    func test_online_fetch_writesJSONFile() async throws {
        let items = [sampleItem(1), sampleItem(2)]
        let cache = WallpaperListCache(fileURL: fileURL)
        let repo = WallpapersRepository(
            imageAPI: ImageAPIStub(items: items),
            cache: cache,
            network: NetworkMonitorMock(connected: true)
        )
        let result = try await repo.fetchImages()
        XCTAssertEqual(result.source, .Network)
        XCTAssertEqual(result.items.count, 2)
        XCTAssertTrue(FileManager.default.fileExists(atPath: fileURL.path))
        
        let raw = try String(contentsOf: fileURL, encoding: .utf8)
        XCTAssertTrue(raw.contains("image_url"))
        XCTAssertTrue(raw.contains("Wallpaper 1"))
        
        let loaded = try cache.loadWallpaperList()
        XCTAssertEqual(loaded.map(\.id), [1, 2])
        XCTAssertEqual(loaded[0].imageURL.absoluteString, "https://picsum.photos/id/1/600/400")
    }
    
    func test_offline_readsJSON_doesNotCallAPI() async throws {
        let cache = WallpaperListCache(fileURL: fileURL)
        try cache.saveWallpaperList([sampleItem(9)])
        let api = ImageAPIStub(items: [sampleItem(1)])
        let repo = WallpapersRepository(
            imageAPI: api,
            cache: cache,
            network: NetworkMonitorMock(connected: false)
        )
        let result = try await repo.fetchImages()
        XCTAssertEqual(result.source, .Cache)
        XCTAssertEqual(result.items.first?.id, 9)
        XCTAssertEqual(api.fetchCount, 0)
    }
    func test_onlineAPIFails_fallsBackToJSON() async throws {
        let cache = WallpaperListCache(fileURL: fileURL)
        try cache.saveWallpaperList([sampleItem(3)])
        let repo = WallpapersRepository(
            imageAPI: ImageAPIStub(error: APIError.httpError(500)),
            cache: cache,
            network: NetworkMonitorMock(connected: true)
        )
        let result = try await repo.fetchImages()
        XCTAssertEqual(result.source, .Cache)
        XCTAssertEqual(result.items.first?.id, 3)
    }
    
    func test_offline_noFile_throws() async {
        let repo = WallpapersRepository(
            imageAPI: ImageAPIStub(items: [sampleItem()]),
            cache: WallpaperListCache(fileURL: fileURL),
            network: NetworkMonitorMock(connected: false)
        )
        do {
            _ = try await repo.fetchImages()
            XCTFail("expected noCacheForOfflineData")
        } catch let error as APIError {
            XCTAssertEqual(error, .noCacheForOfflineData)
        } catch {
            XCTFail("wrong error \(error)")
        }
    }
}
//helpers
extension WallpapersRepositoryTests {
    private func sampleItem(_ id: Int = 1) -> ImageItemModel {
        ImageItemModel(
            id: id,
            title: "Wallpaper \(id)",
            imageURL: URL(string: "https://picsum.photos/id/\(id)/600/400")!
        )
    }
    private func tempListURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("wallpaper_list_\(UUID().uuidString).json")
    }
}
