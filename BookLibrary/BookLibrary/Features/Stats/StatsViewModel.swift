//
//  StatsViewModel.swift
//  BookLibrary
//
//  Created by Văn Tiến on 01/06/2026.
//

import Combine
import Foundation

class StatsViewModel {
  @Published private(set) var stats: ReadingStats =
    ReadingStats(readingCount: 0, wantToReadCount: 0, finishedCount: 0)

  @Published private(set) var isLoading: Bool = false
  @Published private(set) var errorMessage: String?

  private let repository: BookRepositoryProtocol
  private var cancellables = Set<AnyCancellable>()

  init(repository: BookRepositoryProtocol = Repository()) {
    self.repository = repository
  }

  func fetchStats() {
    self.isLoading = true
    self.errorMessage = nil
    repository.fetchReadingStats()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        guard let self = self else { return }
        self.isLoading = false
        switch completion {
        case .finished:
          break
        case .failure(let error):
          self.errorMessage = error.localizedDescription

        }
      } receiveValue: { [weak self] stats in
        guard let self = self else { return }
        self.stats = stats
      }
      .store(in: &cancellables)
  }
}
