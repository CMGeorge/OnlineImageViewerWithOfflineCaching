import Foundation
//
//  NetworkComunication.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//


class APIService: ImageRetrivalProtocol {
    enum APIServiceEndpoints {
        static let wallpapers = "wallpapers"
    }
    
    private let session: URLSession = .shared
    private let baseURL: String = "https://6a994a2f53c0481726b91819.mockapi.io/api/v1/"
    
    // We can create an init here if we want to pass base URL or session instances
    
    // fetch data using current session
    func fetchImages() async throws -> [ImageItemModel] {
        let urlString = baseURL + APIServiceEndpoints.wallpapers
        //make sure we can convert the string to a valid url
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        //retrieve datalist from server
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.httpError(httpResponse.statusCode)
        }
        let decoder = JSONDecoder()
        return try decoder.decode([ImageItemModel].self, from: data)
    }
}

