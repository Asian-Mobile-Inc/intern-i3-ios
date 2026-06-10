//
//  BookDetailViewModel.swift
//  BookLibrary
//
//  Created by Văn Tiến on 04/06/2026.
//

import Foundation
import Combine

@MainActor
class BookDetailViewModel {
    let book: Book
    
    @Published private(set) var isSaved: Bool = false
    @Published private(set) var isSaving: Bool = false
    @Published private(set) var message: String?
    private let saveBookUseCase : SaveBookUseCaseProtocol
    
    init(book: Book, saveBookUseCase : SaveBookUseCaseProtocol) {
        self.book = book
        self.saveBookUseCase = saveBookUseCase
        Task {
            await loadSavedState()
        }
    }
    
    func loadSavedState() async {
        do {
            isSaved = try await saveBookUseCase.isSaved(book)
        } catch {
            message = error.localizedDescription
        }
    }

    func saveBook() async { 
        guard !isSaving, !isSaved else { return }

        isSaving = true
        defer { isSaving = false }

        do {
            try await saveBookUseCase.execute(book)
            isSaved = true
            message = "Saved Successfully"

        } catch SaveBookError.alreadyExists {
            isSaved = true
            message = "This book is already saved"
        } catch {
            message = " Cannot save this book, please try again!"
        }
    }
}
