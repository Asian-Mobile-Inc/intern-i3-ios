//
//  Repository.swift
//  BookLibrary
//
//  Created by Văn Tiến on 02/06/2026.
//

import Foundation
import Combine

class Repository: BookRepositoryProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func searchBooks(query: String) -> AnyPublisher<[Book], NetworkError> {
        apiService.request(
            .searchBooks(query: query),
            responseType: BookSearchResponse.self
        )
        .map { response in
            response.docs.compactMap { $0.toBook() }
        }
        .eraseToAnyPublisher()
    }
}

protocol BookRepositoryProtocol {
    func searchBooks(query: String) -> AnyPublisher<[Book], NetworkError>
}
