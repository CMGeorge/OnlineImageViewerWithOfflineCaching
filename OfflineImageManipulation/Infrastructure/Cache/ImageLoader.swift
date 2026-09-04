//
//  ImageLoader.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 04/09/2026.
//

//Singleton image loader

import Foundation
import UIKit  //to return UIImage

actor ImageLoader {
    enum ImageLoadError: Error {
        case invalidData
        case offlineAndNotCached
        case loacalCache
    }

    static let shared = ImageLoader()

    private let cache: CacheImage
    private let session: URLSession

    //we should not allow retrival of same url concurent
    private var ongoingDownloads: [URL: Task<Data, Error>] = [:]

    init(
        cache: CacheImage = CacheImage(),
        session: URLSession = .shared
    ) {
        self.cache = cache
        self.session = session
    }
    func retrieveImage(for url: URL, allowNetwork: Bool = true) async throws
        -> Data
    {
//        print("Start retrive image")
        if let existing = ongoingDownloads[url] {
//            print("Return data from cache")
            return try await existing.value
        }
        let task = Task<Data, Error> {
            if let data = cache.load(for: url) {
//                print("Return data from cache using task")
                return data
            }
            if !allowNetwork {
                throw ImageLoadError.offlineAndNotCached
            }
            let (data, _) = try await session.data(from: url)
            
            try? cache.save(data: data, for: url)
//            print("Return data after save")
            
            return data
        }
        ongoingDownloads[url] = task
        defer { ongoingDownloads[url] = nil }

        return try await task.value

    }
}
