//
//  BookRepositoryProtocol.swift
//  BookLibrary
//
//  Created by Văn Tiến on 10/06/2026.
//

import Foundation
import Combine

protocol BookRepositoryProtocol {
    func searchBooks(query: String) -> AnyPublisher<[Book], Error>
    func fetchSavedBooks() -> AnyPublisher<[SavedBook], Error>
    func saveBook(_ book: Book) -> AnyPublisher<Void, Error>
    func deleteBook(id: String) -> AnyPublisher<Void, Error>
    func updateBook(_ book: SavedBook) -> AnyPublisher<Void, Error>
    func isBookSaved(id: String) -> AnyPublisher<Bool, Error>
    func fetchReadingStats() -> AnyPublisher<ReadingStats, Error>
}
