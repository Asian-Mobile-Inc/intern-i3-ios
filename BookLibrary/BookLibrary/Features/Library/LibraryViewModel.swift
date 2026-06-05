//
//  LibraryViewModel.swift
//  BookLibrary
//
//  Created by Văn Tiến on 01/06/2026.
//

import Foundation
import Combine

class LibraryViewModel {
    @Published var savedBooks: [SavedBook] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let repository: Repository
    private var cancellables = Set<AnyCancellable>()

    init(repository: Repository = Repository()) {
        self.repository = repository
    }

    func fetchSavedBooks() {
        isLoading = true
        errorMessage = nil

        repository.fetchSavedBooks()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                self.isLoading = false

                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    self.savedBooks = []
                }
            } receiveValue: { [weak self] books in
                self?.savedBooks = books
            }
            .store(in: &cancellables)
    }

    func updateBook(_ book: SavedBook) {
        repository.updateBook(book)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { }
            .store(in: &cancellables)
    }
}
