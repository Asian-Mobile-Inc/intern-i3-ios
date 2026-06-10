//
//  SaveBookUseCaseProtocol.swift
//  BookLibrary
//
//  Created by Văn Tiến on 10/06/2026.
//

import Foundation

protocol SaveBookUseCaseProtocol {
    func isSaved(_ book: Book) async throws -> Bool
    func execute(_ book: Book) async throws
}
