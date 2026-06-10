//
//  QuoteViewModel.swift
//  MVC
//
//  Created by Văn Tiến on 22/05/2026.
//

import Foundation

enum fetchDataState {
    case loading
    case loaded
    case error(String)
}
class QuoteViewModel {
    private let quoteService = QuoteService()
    
    var quotes: [Quote] = []
    
    var onStateChanged : ((fetchDataState) -> Void)?
    
    func fetchData() {
        quoteService.delegate = self
        quoteService.fetchQuotes()
    }
}

extension QuoteViewModel: QuoteServiceDelegate {
    
    func quoteService(_ service: QuoteService, didFetchQuotes quotes: [Quote]) {
        onStateChanged?(.loading)
        DispatchQueue.main.async { [weak self] in
            self?.quotes = quotes
            self?.onStateChanged?(.loaded)
        }
        print(quotes)
    }
    
    func quoteService(_ service: QuoteService, didFailedWithError : String) {
        DispatchQueue.main.async { [weak self] in
           self?.onStateChanged?(.error(didFailedWithError))
       }
    }
}
