//
//  QuoteViewController.swift
//  MVC
//
//  Created by Văn Tiến on 12/05/2026.
//

import UIKit

class QuoteViewController: UIViewController {
    
    private let mainView = QuoteDisplayView()
    
    private let quoteService = QuoteService()
    
    private var quotes: [Quote] = []

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quotes"
        setupBindings()
        
        quoteService.fetchQuotes()
    }
    
    // MARK: - Config
    private func setupBindings() {
        quoteService.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNetworkError(_:)),
            name: .quoteServiceDidFail,
            object: nil
        )
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    @objc private func handleNetworkError(_ notification: Notification) {
        let errorMessage = notification.userInfo?["errorMessage"] as? String ?? "Unkowned Error"
        
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - QuoteServiceDelegate
extension QuoteViewController: QuoteServiceDelegate {
    
    func quoteService(_ service: QuoteService, didFetchQuote quote: Quote) {
        DispatchQueue.main.async { [weak self] in
            self?.quotes.append(quote)
            self?.mainView.tableView.reloadData()
        }
    }
    
    func quoteService(_ service: QuoteService, didFetchQuotes quotes: [Quote]) {
        DispatchQueue.main.async { [weak self] in
            self?.quotes = quotes
            self?.mainView.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension QuoteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as? QuoteCell else {
            return UITableViewCell()
        }
        
        let quote = quotes[indexPath.row]
        cell.configure(with: quote, at: indexPath.row)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension QuoteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - QuoteCellDelegate
extension QuoteViewController: QuoteCellDelegate {
    
    func quoteCell(_ cell: QuoteCell, didTapHeartAt index: Int) {
        guard index < quotes.count else { return }
        quotes[index].isSelected.toggle()
    }
}
