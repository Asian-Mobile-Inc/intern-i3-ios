//
//  SavedBook.swift
//  BookLibrary
//
//  Created by Văn Tiến on 04/06/2026.
//

import Foundation

enum SavedBookState {
    case wantToRead
    case reading
    case read
    
    var rawValue: String {
        switch self {
            
        case .wantToRead:
            return "Want To Read"
            
        case .reading:
            return "Reading"
            
        case .read:
            return "Read"
        }
        
    }
}
class SavedBook : Hashable {
    let id: String
    let title: String
    let author: String
    let firstPublishYear: Int?
    let coverID: Int?
    var note : String = ""
    var rating : Double
    var status : String = "Want To Read"
    var creatAt : Date = .now
    var coverURL: URL? {
        guard let coverID else {
            return nil
        }
        
        return URL(string: "https://covers.openlibrary.org/b/id/\(coverID)-M.jpg")
    }
    
    func hash(into hasher: inout Hasher) {
             hasher.combine(id)
    }
    
    static func == (lhs: SavedBook, rhs: SavedBook) -> Bool {
        lhs.id == rhs.id && lhs.note == rhs.note && lhs.rating == lhs.rating
    }
    
    init ( entity: SavedBookEntity) {
        self.id = entity.id ?? UUID().uuidString
        self.author = entity.author ?? "Unknown Author"
        self.title = entity.title ?? "Unknown book title"
        self.firstPublishYear = Int(entity.publicYear)
        self.coverID = Int(entity.coverID)
        self.note = entity.note ?? ""
        self.rating = entity.rating
        self.status = entity.status ?? "Want To Read"
        self.creatAt = entity.createAt ?? .now
    }
    
    
}

extension SavedBookEntity {
    func update (from savedBook: SavedBook) {
        self.id = savedBook.id
        self.title = savedBook.title
        self.author = savedBook.author
        self.publicYear = Int64(savedBook.firstPublishYear ?? 0)
        self.note = savedBook.note
        self.rating = savedBook.rating
        self.status = savedBook.status
        self.createAt = savedBook.creatAt
    }
    
    func updateFromBook (from book: Book) {
        self.id = book.id
        self.title = book.title
        self.author = book.author
        self.publicYear = Int64(book.firstPublishYear ?? 0)
        self.note = ""
        self.rating = 0.0
        self.status = "Want To Read"
        self.createAt = .now
    }
}
