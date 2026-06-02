//
//  APIService.swift
//  BookLibrary
//
//  Created by Văn Tiến on 02/06/2026.
//

import Foundation
import Combine

class APIService: APIServiceProtocol {
    func request<T: Decodable> ( _ endpoint: APIEndpoint, responseType: T.Type) -> AnyPublisher<T, NetworkError> {
        
        guard let url = endpoint.url else {
                    return Fail(error: NetworkError.invalidURL)
                        .eraseToAnyPublisher()
                }
                
                return URLSession.shared.dataTaskPublisher(for: url)
                    .tryMap { data, response in
                        
                        guard let httpResponse = response as? HTTPURLResponse else {
                            throw NetworkError.invalidResponse
                        }
                        
                        guard 200...299 ~= httpResponse.statusCode else {
                            throw NetworkError.badStatusCode(httpResponse.statusCode)
                        }
                        
                        return data
                    }
                    .decode(type: T.self, decoder: JSONDecoder())
                    .mapError { error in
                        if let networkError = error as? NetworkError {
                            return networkError
                        }
                        
                        if error is DecodingError {
                            print("Decode error:", error)
                            return NetworkError.decodingFailed
                        }
                        
                        return NetworkError.unknown(error)
                    }
                    .eraseToAnyPublisher()
    }
}

protocol APIServiceProtocol {
    func request<T: Decodable> ( _ endPoint: APIEndpoint, responseType: T.Type) -> AnyPublisher<T, NetworkError>
}
