//
//  QuoteService.swift
//  MVC
//
//  Created by Văn Tiến on 12/05/2026.
//

import Foundation

protocol QuoteServiceDelegate: AnyObject {
    func quoteService(_ service: QuoteService, didFetchQuote quote: Quote)
    func quoteService(_ service: QuoteService, didFetchQuotes quotes: [Quote])
}
extension Notification.Name {
    static let quoteServiceDidFail = Notification.Name("quoteServiceDidFail")
}

class QuoteService {
    weak var delegate: QuoteServiceDelegate?
    
    func fetchRandomQuote() {
        guard let url = URL(string: "https://dummyjson.com/quotes/random") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                NotificationCenter.default.post(
                    name: .quoteServiceDidFail,
                    object: nil,
                    userInfo: ["errorMessage": error.localizedDescription]
                )
                return
            }
            
            guard let data = data else { return }
            do {
                let quote = try JSONDecoder().decode(Quote.self, from: data)
               self.delegate?.quoteService(self, didFetchQuote: quote)
                
            } catch {
                NotificationCenter.default.post(
                    name: .quoteServiceDidFail,
                    object: nil,
                    userInfo: ["errorMessage": "Lỗi parse dữ liệu JSON!"]
                )
            }
        }
        task.resume()
    }
    
    func fetchQuotes() {
        guard let url = URL(string: "https://dummyjson.com/quotes?limit=20") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                NotificationCenter.default.post(
                    name: .quoteServiceDidFail,
                    object: nil,
                    userInfo: ["errorMessage": error.localizedDescription]
                )
                return
            }
            
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(QuoteResponse.self, from: data)
                
                self.delegate?.quoteService(self, didFetchQuotes: response.quotes)
                
            } catch {
                NotificationCenter.default.post(
                    name: .quoteServiceDidFail,
                    object: nil,
                    userInfo: ["errorMessage": "Lỗi parse dữ liệu JSON!"]
                )
            }
        }
        task.resume()
    }
}
