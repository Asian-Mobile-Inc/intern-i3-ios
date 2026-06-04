//
//  BookDetailViewModel.swift
//  BookLibrary
//
//  Created by Văn Tiến on 04/06/2026.
//

import Foundation
import Combine

class BookDetailViewModel {
    let book: Book
    @Published private(set) var isSaved: Bool
    @Published var message: String?
    private static let savedBookIDsKey = "savedBookIDs"
    
    init(book: Book) {
        self.book = book
        self.isSaved = Self.savedBookIDs.contains(book.id)
    }
    
    func saveBook() {
        guard !isSaved else {
            return
        }
        
        var savedBookIDs = Self.savedBookIDs
        savedBookIDs.insert(book.id)
        UserDefaults.standard.set(Array(savedBookIDs), forKey: Self.savedBookIDsKey)
        isSaved = true
        message = "Book saved to your library."
    }
    
    private static var savedBookIDs: Set<String> {
        Set(UserDefaults.standard.stringArray(forKey: savedBookIDsKey) ?? [])
    }
}
