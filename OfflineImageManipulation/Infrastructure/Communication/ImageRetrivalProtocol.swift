//
//  ImageRetrival.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//

 protocol ImageRetrivalProtocol:AnyObject {
    func fetchImages() async throws -> [ImageItemModel]
}
