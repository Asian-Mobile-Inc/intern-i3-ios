//
//  SearchViewModel.swift
//  BookLibrary
//
//  Created by Văn Tiến on 01/06/2026.
//

import Combine
import Foundation

class SearchViewModel {
  @Published var isLoading: Bool = false
  @Published var errorMessage: String? = nil
  @Published var books: [Book] = []
  @Published var searchText: String = ""

  private var repository: Repository
  private var cancellables = Set<AnyCancellable>()

  init(repository: Repository = Repository()) {
    self.repository = repository
    bindSearchText()
  }

  func bindSearchText() {
    self.$searchText
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .removeDuplicates()
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .map { [weak self] query -> AnyPublisher<[Book], Never> in
        guard let self else {
          return Just([])
            .eraseToAnyPublisher()
        }

        if query.isEmpty {
          self.books = []
          self.errorMessage = nil
          self.isLoading = false

          return Just([])
            .eraseToAnyPublisher()
        }

        self.isLoading = true
        self.errorMessage = nil

        return self.repository.searchBooks(query: query)
          .receive(on: DispatchQueue.main)
          .handleEvents(receiveOutput: { [weak self] _ in
            self?.isLoading = false
            self?.errorMessage = nil
          })
          .catch { [weak self] error -> Just<[Book]> in
            self?.isLoading = false
            self?.errorMessage = error.localizedDescription
            return Just([])
          }
          .eraseToAnyPublisher()
      }
      .switchToLatest()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] books in
        guard let self else { return }

        self.books = books
      }
      .store(in: &cancellables)
  }
}
