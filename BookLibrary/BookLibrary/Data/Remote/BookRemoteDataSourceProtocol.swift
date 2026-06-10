//
//  BookRemoteDataSourceProtocol.swift
//  BookLibrary
//
//  Created by Văn Tiến on 10/06/2026.
//

import Foundation
import Combine

protocol BookRemoteDataSourceProtocol {
    func searchBooks(query: String) -> AnyPublisher<[BookDTO], NetworkError>
}
