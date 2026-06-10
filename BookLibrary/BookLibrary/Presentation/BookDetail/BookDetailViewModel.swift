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
    private let repository : BookRepositoryProtocol
    
    @Published private(set) var isSaved: Bool = false
    @Published var message: String?
    private var cancellabels = Set<AnyCancellable>()
    
    init(book: Book, repository : BookRepositoryProtocol = Repository()) {
        self.book = book
        self.repository = repository
        self.isSavedBook(id : book.id)
    }
    
    func saveBook() {
        repository.saveBook(book)
            .receive(on: DispatchQueue.main)
            .sink (
                receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.isSaved = true
                    self.message = "This book saved to your library."
                case .failure(let error):
                    self.message = error.localizedDescription
                }
            }, receiveValue: { _ in })
            .store(in: &cancellabels)
        
    }
    func isSavedBook(id : String) -> Void {
        repository.isBookSaved(id: id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        
                        break
                    case .failure(let error):
                        self?.message = error.localizedDescription
                    }
                
            }, receiveValue: { [weak self] isSavedBook in
                self?.isSaved = isSavedBook
            })
            .store(in: &cancellabels)
    }
}
