//
//  SavedBookDetailViewModel.swift
//  BookLibrary
//
//  Created by Văn Tiến on 05/06/2026.
//

import Foundation
import Combine

class SavedBookDetailViewModel {
    let savedBook : SavedBook
    let repository : BookRepositoryProtocol
    
    @Published var isUpdated : Bool = false
    @Published var message: String?
    private var cancellabels = Set<AnyCancellable>()
    
    init(savedBook: SavedBook, repository: BookRepositoryProtocol = Repository()) {
        self.savedBook = savedBook
        self.repository = repository
    }
    
    func updateSavedBook ( book : SavedBook){
        repository.updateBook(book)
            .receive(on: DispatchQueue.main)
            .sink (
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    switch completion {
                    case .finished:
                        self.isUpdated = true
                        self.message = "Your update was saved"
                        
                    case .failure(let failure):
                        self.message = failure.localizedDescription
                    }
                }, receiveValue:  { _ in }
            )
            .store(in: &cancellabels)
    }
}
