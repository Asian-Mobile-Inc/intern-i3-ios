//
//  TodoService.swift
//  APINetworking
//
//  Created by Văn Tiến on 25/05/2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case decodingFailed
    case noData
}
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL không hợp lệ"
        case .invalidResponse:
            return "Response không hợp lệ"
        case .badStatusCode(let code):
            return "Server trả về mã lỗi \(code)"
        case .decodingFailed:
            return "Không thể đọc dữ liệu từ server"
        case .noData:
            return "Không có dữ liệu"
        }
    }
}

class TodoService {
    func request<T: Decodable> ( urlString: String, reponseType: T.Type) async throws -> T {
        
        guard let url = URL(string: urlString) else {
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
            throw NetworkError.decodingFailed
        }
    }
}
