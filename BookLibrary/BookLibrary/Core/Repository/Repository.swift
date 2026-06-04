//
//  Repository.swift
//  BookLibrary
//
//  Created by Văn Tiến on 02/06/2026.
//

import Foundation
import Combine
import CoreData

protocol BookRepositoryProtocol {
    func searchBooks(query: String) -> AnyPublisher<[Book], NetworkError>
    func fetchSavedBooks() -> AnyPublisher<[SavedBook], Error>
    func saveBook(_ book: Book) -> AnyPublisher<Void, Error>
    func deleteBook(id: String) -> AnyPublisher<Void, Error>
    func updateBook(_ book: SavedBook) -> AnyPublisher<Void, Error>
    func isBookSaved(id: String) -> AnyPublisher<Bool, Error>
}

protocol BookLocalDataSourceProtocol {
    func fetchSavedBooks() -> AnyPublisher<[SavedBook], Error>
    func saveBook(_ book: Book) -> AnyPublisher<Void, Error>
    func deleteBook(id: String) -> AnyPublisher<Void, Error>
    func updateBook(_ book: SavedBook) -> AnyPublisher<Void, Error>
    func isBookSaved(id: String) -> AnyPublisher<Bool, Error>
}

class Repository: BookRepositoryProtocol {
    
    private let apiService: APIServiceProtocol
    private let bookLocalDS : BookLocalDataSourceProtocol
    
    init(apiService: APIServiceProtocol = APIService(),
         bookLocalDS: BookLocalDataSourceProtocol = BookLocalDataSource())
    {
        self.apiService = apiService
        self.bookLocalDS = bookLocalDS
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
        { [weak self] promise in
            
            guard let self = self else { return }
            
            do {
                let request : NSFetchRequest = SavedBookEntity.fetchRequest()
                
                let entities = try context.fetch(request)
                
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
        return Future<Void, Error> { [weak self] promisse in
            guard let self = self else { return }
            
            do {
                let request = SavedBookEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", book.id )
                
                let existingBook = try context.fetch(request)
                
                if existingBook.isEmpty {
                    let savedBook = SavedBookEntity(context: context)
                    savedBook.updateFromBook(from: book)
                    try context.save()
                    promisse(.success(()))
                }
                
                return
                
            } catch {
                promisse(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteBook(id: String) -> AnyPublisher<Void, any Error> {
        return Future<Void, Error> { [weak self] promise in
            
            guard let self = self else { return }
            
            do {
                let request = SavedBookEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id)
                
                let book = try context.fetch(request)
                
                guard let bookToDelete = book.first else {
                    promise(.success(()))
                    return
                }
                
                context.delete(bookToDelete)
                try context.save()
                
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateBook(_ book: SavedBook) -> AnyPublisher<Void, any Error> {
        return Future<Void, Error> { [weak self] promise in
            
            guard let self = self else { return }
            
            do {
                let request = SavedBookEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", book.id)
                
                let books = try context.fetch(request)
                
                guard let bookToUpdate = books.first else {
                    promise(.success(()))
                    return
                }
                
                bookToUpdate.update(from: book)
                try context.save()
                promise(.success(()))
                
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
            
    }
    
    func isBookSaved(id: String) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error> { [weak self] promise in
            
            guard let self = self else { return }
            
            do {
                let request = SavedBookEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id)
                
                let book = try context.fetch(request)
                
                if book.first != nil {
                    promise(.success(true))
                }
                else {
                    promise(.success(false))
                    return
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
