//
//  SearchBookUseCaseProtocol.swift
//  BookLibrary
//
//  Created by Văn Tiến on 10/06/2026.
//

import Foundation
import Combine

protocol SearchBooksUseCaseProtocol {
    func execute(query: String) -> AnyPublisher<[Book], Error>
}

