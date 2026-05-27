//
//  HomeViewModel.swift
//  APINetworking
//
//  Created by Văn Tiến on 25/05/2026.
//

import Foundation

class HomeViewModel {
    var todos : [Todo] = []
    private let service = TodoService()
    var onOutput : ((Result<String, Error>) -> Void)?
    func fetchData() async {
        do {
            let todos = try await service.request(urlString: "https://jsonplaceholder.typicode.com/todos", reponseType: [Todo].self)
            self.todos = todos
            onOutput?(.success("Loading data completed"))
        } catch {
            onOutput?(.failure(error))
        }
    }
    
    func reloadUI() {
        
    }
    func showError(message: String) {
        print(message)
    }
}
