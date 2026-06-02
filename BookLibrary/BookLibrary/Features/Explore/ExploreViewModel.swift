//
//  ExploreViewModel.swift
//  BookLibrary
//
//  Created by Văn Tiến on 01/06/2026.
//

import Foundation
import Combine

enum ExploreSection: Hashable, CaseIterable {
    case featured
    case popular
    case recommended
    
    var title: String {
        switch self {
        case .featured:
            return "Featured Books"
        case .popular:
            return "Popular Books"
        case .recommended:
            return "Recommended Books"
        }
    }
}

final class ExploreViewModel {
    
    @Published private(set) var sections: [ExploreSection: [Book]] = [:]
    
    func loadMockData() {
        let books = Book.mockBook
        
        sections = [
            .featured: Array(books.prefix(2)),
            .popular: books,
            .recommended: books
        ]
    }
}
