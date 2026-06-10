//
//  Repository.swift
//  BookLibrary
//
//  Created by Văn Tiến on 02/06/2026.
//

import Foundation
import Combine
import CoreData


class Repository: BookRepositoryProtocol {
    func fetchReadingStats() -> AnyPublisher<ReadingStats, any Error> {
        bookLocalDS.fetchSavedBooks()
            .map { books in
                let wantToRead = books.filter { $0.status == SavedBookState.wantToRead.rawValue }.count
                let reading = books.filter { $0.status == SavedBookState.reading.rawValue }.count
                let finished = books.filter { $0.status == SavedBookState.read.rawValue }.count
                
                return ReadingStats(
                    readingCount: reading,
                    wantToReadCount: wantToRead,
                    finishedCount: finished )
            }
            .eraseToAnyPublisher()
        }
    
    
//    private let apiService: APIServiceProtocol
    private let bookLocalDS : BookLocalDataSourceProtocol
    private let bookRemoteDS : BookRemoteDataSourceProtocol
    
    init(bookLocalDS: BookLocalDataSourceProtocol = BookLocalDataSource(),
         bookRemoteDS : BookRemoteDataSourceProtocol = BookRemoteDataSource() )
    {
        
        self.bookLocalDS = bookLocalDS
        self.bookRemoteDS = bookRemoteDS
    }
    
    func searchBooks(query: String) -> AnyPublisher<[Book], Error> {
        bookRemoteDS.searchBooks(query: query)
        .map { booksDTO in
            let books = booksDTO.compactMap { $0.toBook() }
            let uniqueBooks = Dictionary(grouping: books, by: \.id)
                .compactMap { $0.value.first }
            
            return uniqueBooks
        }
        .mapError { $0 as Error }
        .eraseToAnyPublisher()
    }


    
    func fetchSavedBooks() -> AnyPublisher<[SavedBook], any Error> {
        bookLocalDS.fetchSavedBooks()
    }
    
    func saveBook(_ book: Book) async throws {
        try await bookLocalDS.saveBook(book)
    }
    
    func deleteBook(id: String) -> AnyPublisher<Void, any Error> {
        bookLocalDS.deleteBook(id: id)
    }
    
    func updateBook(_ book: SavedBook) -> AnyPublisher<Void, any Error> {
        bookLocalDS.updateBook(book)
    }
    
    func isBookSaved(id: String) async throws -> Bool {
        return try await bookLocalDS.isBookSaved(id: id)
    }
}
