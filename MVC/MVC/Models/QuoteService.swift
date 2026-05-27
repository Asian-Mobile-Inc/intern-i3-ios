//
//  QuoteService.swift
//  MVC
//
//  Created by Văn Tiến on 12/05/2026.
//

import Foundation

protocol QuoteServiceDelegate: AnyObject {
    func quoteService(_ service: QuoteService, didFetchQuotes quotes: [Quote])
    func quoteService(_ service: QuoteService, didFailedWithError : String )
}

class QuoteService {
    weak var delegate: QuoteServiceDelegate?
    
    
    func fetchQuotes()  {
        
        guard let url = URL(string: "https://dummyjson.com/quotes?limit=20") else {
            self.delegate?.quoteService(self, didFailedWithError: "URL is not available")
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            guard let http = response as? HTTPURLResponse else {
                delegate?.quoteService(self, didFailedWithError: "Invalid response")
                return
            }

            guard (200...299).contains(http.statusCode) else {
                delegate?.quoteService(self, didFailedWithError: "HTTP \(http.statusCode)")
                return
            }
            
            if let error = error {
                return
            }
            
            guard let data = data else {
                return
            }
            do {
                let response = try JSONDecoder().decode(QuoteResponse.self, from: data)
                
                self.delegate?.quoteService(self, didFetchQuotes: response.quotes)
                
            } catch {
                self.delegate?.quoteService(self, didFailedWithError: "Failed to decode data")
            }
        }
        task.resume()
    }
}
