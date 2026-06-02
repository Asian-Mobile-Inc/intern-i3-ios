//
//  APIService.swift
//  BookLibrary
//
//  Created by Văn Tiến on 02/06/2026.
//

import Foundation

class APIService {
    func request<T: Decodable> ( _ endPoint: APIEndpoint, responseType: T.Type) async throws -> T {
        
        guard let url = endPoint.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.badStatusCode(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decode Error", error)
            throw NetworkError.decodingFailed
        }
    }
}
