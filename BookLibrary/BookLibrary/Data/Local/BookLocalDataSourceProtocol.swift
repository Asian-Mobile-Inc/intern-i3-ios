//
//  BookLocalDataSourceProtocol.swift
//  BookLibrary
//
//  Created by Văn Tiến on 10/06/2026.
//

import Foundation
import Combine

protocol BookLocalDataSourceProtocol {
    func fetchSavedBooks() -> AnyPublisher<[SavedBook], Error>
    func saveBook(_ book: Book) async throws
    func deleteBook(id: String) -> AnyPublisher<Void, Error>
    func updateBook(_ book: SavedBook) -> AnyPublisher<Void, Error>
    func isBookSaved(id: String) async throws -> Bool
}
