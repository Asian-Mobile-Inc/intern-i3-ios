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
    func fetchData() {
        service.fetchTodos { [weak self] result in
            switch result {
                
            case .success(let datas):
                self?.todos = datas
                self?.onOutput?(.success("Fetch data successful"))
//                DispatchQueue.main.async {
//                    self?.todos = datas
//                    self?.reloadUI()
//                }
            
            case .failure(let error):
                self?.onOutput?(.failure(error))
//                DispatchQueue.main.async {
//                    self?.showError(message: error.localizedDescription)
//                }
            }
            
        }
    }
    
    func reloadUI() {
        
    }
    func showError(message: String) {
        print(message)
    }
}
