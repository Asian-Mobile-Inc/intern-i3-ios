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
    
    private let repository: BookRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: BookRepositoryProtocol = Repository()) {
    self.repository = repository
    }
    
    func loadMockData() {
        let books = Book.mockBook
        
        sections = [
            .featured: Array(books.prefix(2)),
            .popular: books,
            .recommended: books
        ]
    }
    func fetchData() {
        isLoading = true
        errorMessage = nil
        
        repository.searchBooks(query: "lifestyle")
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                
                self.isLoading = false
                
                switch completion {
                case .finished:
                    break
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                
            } receiveValue: { [weak self] books in
                guard let self else { return }
                
                self.sections = [
                    .featured: Array(books.prefix(3)),
                    .popular: Array(books.dropFirst(3).prefix(8)),
                    .recommended: Array(books.dropFirst(11).prefix(8))
                ]
            }
            .store(in: &cancellables)
 
        
    }
}
