//
//  SearchViewModel.swift
//  BookLibrary
//
//  Created by Văn Tiến on 01/06/2026.
//

import Foundation
import Combine

class SearchViewModel {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var books : [Book] = []
    @Published var searchText : String = ""
    
    private var repository : Repository
    private var cancellables = Set<AnyCancellable>()
    
    init( repository : Repository = Repository()) {
        self.repository = repository
        bindSearchText()
    }
    
    func bindSearchText() {
        self.$searchText
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .map { [weak self] query -> AnyPublisher<[Book], NetworkError> in
               guard let self else {
                   return Just([])
                       .setFailureType(to: NetworkError.self)
                       .eraseToAnyPublisher()
               }
               
               if query.isEmpty {
                   self.books = []
                   self.errorMessage = nil
                   self.isLoading = false
                   
                   return Just([])
                       .setFailureType(to: NetworkError.self)
                       .eraseToAnyPublisher()
               }
               
               self.isLoading = true
               self.errorMessage = nil
               
               return self.repository.searchBooks(query: query)
                   .eraseToAnyPublisher()
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
               guard let self else { return }
               
               self.isLoading = false
               
               if case .failure(let error) = completion {
                   self.errorMessage = error.localizedDescription
                   self.books = []
               }
            } receiveValue: { [weak self] books in
               guard let self else { return }
               
               self.isLoading = false
               self.books = books
            }
            .store(in: &cancellables)
    }
}
