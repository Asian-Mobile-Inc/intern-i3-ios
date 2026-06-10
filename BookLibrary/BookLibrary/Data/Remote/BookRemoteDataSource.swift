//
//  BookRemoteDataSource.swift
//  BookLibrary
//
//  Created by Văn Tiến on 10/06/2026.
//

import Foundation
import Combine

class BookRemoteDataSource: BookRemoteDataSourceProtocol {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func searchBooks(query: String) -> AnyPublisher<[BookDTO], NetworkError> {
        apiService.request(
            .searchBooks(query: query),
            responseType: BookSearchResponse.self
        )
        .map { response in
            return response.docs
        }
        .eraseToAnyPublisher()
    }
}
