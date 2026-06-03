//
//  Book.swift
//  BookLibrary
//
//  Created by Văn Tiến on 01/06/2026.
//

import Foundation

class Book : Hashable {
    let id: String
    let title: String
    let author: String
    let firstPublishYear: Int?
    let coverID: Int?
    
    var coverURL: URL? {
       guard let coverID else {
           return nil
       }
       
       return URL(string: "https://covers.openlibrary.org/b/id/\(coverID)-M.jpg")
   }
    func hash(into hasher: inout Hasher) {
             hasher.combine(id)
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: String, title: String, author: String, firstPublishYear: Int?, coverID: Int?) {
        self.id = id
        self.title = title
        self.author = author
        self.firstPublishYear = firstPublishYear
        self.coverID = coverID
    }
}

extension Book {
    static let mockBook = [
        Book(id: "1", title: "Habit", author: "Robert Martin", firstPublishYear: 2015, coverID: nil),
        Book(id: "2", title: "Sleep", author: "James Cleak", firstPublishYear: 2012, coverID: nil),
        Book(id: "3", title: "Health", author: "Christh Bumstead", firstPublishYear: 2020, coverID: nil),
    ]
}
