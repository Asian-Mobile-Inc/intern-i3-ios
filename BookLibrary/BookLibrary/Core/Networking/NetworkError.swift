//
//  NetworkError.swift
//  BookLibrary
//
//  Created by Văn Tiến on 02/06/2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case decodingFailed
    case noData
    case unknown(Error)
}
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL invalid"
        case .invalidResponse:
            return "Response invalid"
        case .badStatusCode(let code):
            return "Bad status from server \(code)"
        case .decodingFailed:
            return "Decoding Failed"
        case .noData:
            return "Data is empty"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
