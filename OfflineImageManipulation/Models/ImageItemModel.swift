import Foundation

//
//  ImageItemModel.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//


struct ImageItemModel: Codable, Identifiable {
    let id: Int
    let title: String
    let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageURL = "image_url"
    }
}

