//
//  APIError.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//

enum APIError: Error {
    //When server return a error for the api call
    case httpError(Int)
    //when URL string can't be casted to URL (maybe invalid endpoint name or base url)
    case invalidURL
    //unknonw error (can't create a URL Response)
    case invalidResponse
    //issues with the received data
    case decodingError
    //Internet  / API issue without cached data
    case noCacheForOfflineData

}
