//
//  BookLocalDataSource.swift
//  BookLibrary
//
//  Created by Văn Tiến on 10/06/2026.
//

import Foundation
import Combine
import CoreData

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
    
    func saveBook(_ book: Book) async throws {
        let savedBook = SavedBookEntity(context: self.context)
        savedBook.updateFromBook(from: book)
        try self.context.save()
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
    
    func isBookSaved(id: String) async throws -> Bool {

        let request = SavedBookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        
        let book = try self.context.fetch(request)
        
        return book.first != nil
    }
}
