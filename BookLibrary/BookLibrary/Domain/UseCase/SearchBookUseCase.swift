//
//  SearchBookUseCase.swift
//  BookLibrary
//
//  Created by Văn Tiến on 10/06/2026.
//

import Foundation
import Combine

class SearchBookUseCase : SearchBooksUseCaseProtocol {
    private let repository : BookRepositoryProtocol
    init(repository: BookRepositoryProtocol) {
        self.repository = repository
    }
    func execute(query: String) -> AnyPublisher<[Book], Error> {
        let normalizedQuery = query
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        return repository.searchBooks(query: query)
            .map { [weak self] books in
                guard let self else { return books }

                return books.sorted {
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
