//
//  CacheImage.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 04/09/2026.
//
import Foundation
import CryptoKit

nonisolated final class CacheImage:Sendable {
    private let cacheFolder: URL
    
    init(cacheFolder: URL? = nil) {
        if let cacheFolder {
            self.cacheFolder = cacheFolder
        } else {
            //prefere cache because can be auto clean bby OS in case of space missing
            let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            self.cacheFolder = caches.appendingPathComponent("Images", isDirectory: true)
        }
        //we should create the directory if not exists. Asume creation works if not exists
        do {
            try FileManager.default.createDirectory(at: self.cacheFolder, withIntermediateDirectories: true)
        }catch {
            
        }

    }
    private func fileName(for url: URL) -> String {
        let digest = SHA256.hash(data: Data(url.absoluteString.utf8))
        let hex = digest.map { String(format: "%02x", $0) }.joined()
        let ext = url.pathExtension.isEmpty ? "img" : url.pathExtension
        return "\(hex).\(ext)"
    }
    private func fileURL(for url: URL) -> URL {
        self.cacheFolder.appendingPathComponent(fileName(for: url), isDirectory: false)
    }
    
    func save(data: Data, for url: URL) throws {
//        print (" ===== == == == = = == = = url: \(url) - data: \(data.count) to \(self.cacheFolder)")
        let filePath = fileURL(for: url)
        do {
            try data.write(to: filePath, options: .atomic)
        }catch {
#if DEBUG
            print("Imposible to save file")
#endif
        }
#if DEBUG
        print("Save complete to \(filePath)")
#endif
    }
    func load(for url: URL) -> Data? {
        try? Data(contentsOf: fileURL(for: url))
    }
}
