//
//  QuoteViewController.swift
//  MVC
//
//  Created by Văn Tiến on 12/05/2026.
//

import UIKit

class QuoteViewController: UIViewController {
    
    private let mainView = QuoteDisplayView()
    private let viewModel = QuoteViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quotes"
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        setupBindings()
        viewModel.fetchData()
    }
    
    // MARK: - Config
    private func setupBindings() {
        
        viewModel.onStateChanged = { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                break
            case .loaded:
                self.mainView.tableView.reloadData()
            case .error(let message):
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
            
        }
    }
}

// MARK: - QuoteServiceDelegate


// MARK: - UITableViewDataSource
extension QuoteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as? QuoteCell else {
            return UITableViewCell()
        }
        
        let quote = viewModel.quotes[indexPath.row]
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
        guard index < viewModel.quotes.count else { return }
        viewModel.quotes[index].isSelected.toggle()
    }
}
