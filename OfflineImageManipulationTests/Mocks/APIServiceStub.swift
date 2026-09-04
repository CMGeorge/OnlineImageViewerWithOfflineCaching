//
//  APIServiceStub.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 04/09/2026.
//

@testable import OfflineImageManipulation

final class ImageAPIStub: ImageRetrivalProtocol {
    var items: [ImageItemModel]
    var error: Error?
    private(set) var fetchCount = 0
    
    init(items: [ImageItemModel] = [], error: Error? = nil) {
        self.items = items
        self.error = error
    }
    func fetchImages() async throws -> [ImageItemModel] {
        fetchCount += 1
        if let error { throw error }
        return items
    }
}
