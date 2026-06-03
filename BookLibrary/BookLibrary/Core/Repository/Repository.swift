//
//  Repository.swift
//  BookLibrary
//
//  Created by Văn Tiến on 02/06/2026.
//

import Foundation
import Combine

class Repository: BookRepositoryProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func searchBooks(query: String) -> AnyPublisher<[Book], NetworkError> {
        apiService.request(
            .searchBooks(query: query),
            responseType: BookSearchResponse.self
        )
        .map { response in
            let normalizedQuery = query
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            
            let books = response.docs.compactMap { $0.toBook() }
            let uniqueBooks = Dictionary(grouping: books, by: \.id)
                .compactMap { $0.value.first }
            
            return uniqueBooks.sorted {
                self.matchScore(for: $0, query: normalizedQuery) >
                self.matchScore(for: $1, query: normalizedQuery)
            }
        }
        .eraseToAnyPublisher()
    }

    private func matchScore(for book: Book, query: String) -> Int {
        let normalizedTitle = book.title.lowercased()
        let normalizedAuthor = book.author.lowercased()
        
        if normalizedTitle == query { return 5 }
        if normalizedAuthor == query { return 4 }
        if normalizedTitle.hasPrefix(query) { return 3 }
        if normalizedAuthor.hasPrefix(query) { return 2 }
        if normalizedTitle.contains(query) || normalizedAuthor.contains(query) { return 1 }
        return 0
    }
}

protocol BookRepositoryProtocol {
    func searchBooks(query: String) -> AnyPublisher<[Book], NetworkError>
}
