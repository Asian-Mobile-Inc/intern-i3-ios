//
//  TodoService.swift
//  APINetworking
//
//  Created by Văn Tiến on 25/05/2026.
//

import Foundation

class TodoService {
    func fetchTodos ( completion: @escaping (Result<[Todo], Error>) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/todos"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error  = NSError(
                    domain: "NoData",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Data is empty"] )
                completion(.failure(error))
                return
            }
            
            do {
                let todos = try JSONDecoder().decode([Todo].self, from: data)
                completion(.success(todos))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
}
