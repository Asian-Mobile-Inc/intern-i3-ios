//
//  SaveBookUseCase.swift
//  BookLibrary
//
//  Created by Văn Tiến on 10/06/2026.
//

import Foundation

class SaveBookUseCase : SaveBookUseCaseProtocol {
    private let repository : BookRepositoryProtocol
    init(repository: BookRepositoryProtocol) {
        self.repository = repository
    }

    func isSaved(_ book: Book) async throws -> Bool {
        try await repository.isBookSaved(id: book.id)
    }

    func execute(_ book: Book) async throws {
        let isSave = try await repository.isBookSaved(id: book.id)

        if isSave {
            throw SaveBookError.alreadyExists
        }

        try await repository.saveBook(book)
    }
}
