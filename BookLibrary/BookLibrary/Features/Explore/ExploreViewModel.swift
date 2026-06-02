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
@MainActor
final class ExploreViewModel {
    
    @Published private(set) var sections: [ExploreSection: [Book]] = [:]
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    private let apiService : APIService
    var onOutput : ((Result<String,Error>) -> Void)?
    
    init( apiService : APIService = APIService()) {
        self.apiService = apiService
    }
    
    func loadMockData() {
        let books = Book.mockBook
        
        sections = [
            .featured: Array(books.prefix(2)),
            .popular: books,
            .recommended: books
        ]
    }
    func fetchData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await apiService.request(.searchBooks(query: "programming"), responseType: BookSearchResponse.self)
            
            let books = response.docs.compactMap { $0.toBook() }
            
            sections = [
                .featured: Array(books.prefix(3)),
                .popular: Array(books.dropFirst(3).prefix(8)),
                .recommended: Array(books.dropFirst(11).prefix(8))
            ]
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
        
    }
}
