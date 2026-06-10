//
//  ApIEndpoint.swift
//  BookLibrary
//
//  Created by Văn Tiến on 02/06/2026.
//

import Foundation

enum APIEndpoint {
    case searchBooks(query: String)

    var url: URL? {
        switch self {
        case .searchBooks(let query):
            var components = URLComponents(string: "https://openlibrary.org/search.json")
            components?.queryItems = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "limit", value: "20")
            ]
            return components?.url
        }
    }
}
