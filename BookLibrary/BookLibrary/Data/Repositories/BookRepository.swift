//
//  Repository.swift
//  BookLibrary
//
//  Created by Văn Tiến on 02/06/2026.
//

import Foundation
import Combine
import CoreData

protocol BookLocalDataSourceProtocol {
    func fetchSavedBooks() -> AnyPublisher<[SavedBook], Error>
    func saveBook(_ book: Book) -> AnyPublisher<Void, Error>
    func deleteBook(id: String) -> AnyPublisher<Void, Error>
    func updateBook(_ book: SavedBook) -> AnyPublisher<Void, Error>
    func isBookSaved(id: String) -> AnyPublisher<Bool, Error>
}

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
            let normalizedQuery = query
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            
            let books = booksDTO.compactMap { $0.toBook() }
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
    
    func fetchSavedBooks() -> AnyPublisher<[SavedBook], any Error> {
        bookLocalDS.fetchSavedBooks()
    }
    
    func saveBook(_ book: Book) -> AnyPublisher<Void, any Error> {
        bookLocalDS.saveBook(book)
    }
    
    func deleteBook(id: String) -> AnyPublisher<Void, any Error> {
        bookLocalDS.deleteBook(id: id)
    }
    
    func updateBook(_ book: SavedBook) -> AnyPublisher<Void, any Error> {
        bookLocalDS.updateBook(book)
    }
    
    func isBookSaved(id: String) -> AnyPublisher<Bool, any Error> {
        bookLocalDS.isBookSaved(id: id)
    }
}



class BookLocalDataSource : BookLocalDataSourceProtocol {
    private var coreData = CoreDataManager.shared
    private var context = CoreDataManager.shared.context
    
    init(coreData: CoreDataManager = CoreDataManager.shared, context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.coreData = coreData
        self.context = context
    }
    func fetchSavedBooks() -> AnyPublisher<[SavedBook], any Error> {
        return Future<[SavedBook], Error>
        { promise in
            do {
                let request : NSFetchRequest = SavedBookEntity.fetchRequest()
                
                let entities = try self.context.fetch(request)
                
                let savedBooks = entities.map { SavedBook(entity: $0)}
                
                promise(.success(savedBooks))
            }
            catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
        
    }
    
    func saveBook(_ book: Book) -> AnyPublisher<Void, any Error> {
        return Future<Void, Error> { promise in
            do {
                let request = SavedBookEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", book.id )
                request.fetchLimit = 1
                
                let existingBook = try self.context.fetch(request)
                
                if existingBook.isEmpty {
                    let savedBook = SavedBookEntity(context: self.context)
                    savedBook.updateFromBook(from: book)
                    try self.context.save()
                }
                
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteBook(id: String) -> AnyPublisher<Void, any Error> {
        return Future<Void, Error> { promise in
            do {
                let request = SavedBookEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id)
                request.fetchLimit = 1
                
                let book = try self.context.fetch(request)
                
                guard let bookToDelete = book.first else {
                    promise(.success(()))
                    return
                }
                
                self.context.delete(bookToDelete)
                try self.context.save()
                promise(.success(()))
                
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateBook(_ book: SavedBook) -> AnyPublisher<Void, any Error> {
        return Future<Void, Error> { promise in
            do {
                let request = SavedBookEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", book.id)
                request.fetchLimit = 1
                
                let books = try self.context.fetch(request)
                
                guard let bookToUpdate = books.first else {
                    promise(.success(()))
                    return
                }
                
                bookToUpdate.update(from: book)
                try self.context.save()
                promise(.success(()))
                
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
            
    }
    
    func isBookSaved(id: String) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error> { promise in
            do {
                let request = SavedBookEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id)
                request.fetchLimit = 1
                
                let book = try self.context.fetch(request)
                
                promise(.success(book.first != nil))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
