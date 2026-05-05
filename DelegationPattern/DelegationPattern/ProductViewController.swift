//
//  ViewController.swift
//  DelegationPattern
//
//  Created by Văn Tiến on 01/05/2026.
//

import UIKit

class ProductViewController: UIViewController {

    
    
    @IBOutlet weak var tableView : UITableView!
    
    lazy var searchBarView: SearchBarView = {
        let view = SearchBarView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        view.delegate = self
        return view
    }()
    
    var products: [Product] = Product.sampleData
    var filteredProducts: [Product] = []
    var isSearching: Bool { !searchText.isEmpty }
    var searchText = ""
    
    var currentProducts: [Product] {
        return isSearching ? filteredProducts : products
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }

    private func setupTableView() {
        let nib = UINib(nibName: "ProductCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "ProductCell")

        tableView.dataSource = self
        tableView.delegate = self

        tableView.rowHeight = 80
        tableView.separatorStyle = .singleLine
        tableView.tableHeaderView = searchBarView
    }
    
}

extension ProductViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
       let product = currentProducts[indexPath.row]
       cell.configure(with: product)

       cell.delegate = self

       return cell
    }
}

extension ProductViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = currentProducts[indexPath.row]
        showDetail(for: product)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
        [weak self] _, _, completion in
        self?.deleteProduct(at: indexPath)
        completion(true)
    }
                  deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    private func deleteProduct(at indexPath: IndexPath) {
        if isSearching {
            let product = filteredProducts.remove(at: indexPath.row)
            products.removeAll { $0.id == product.id }
        } else {
            products.remove(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    private func showDetail(for product: Product) {
        let alert = UIAlertController(
            title: product.name,
            message: "Giá: \(product.price) ₫\nDanh mục: \(product.category)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - ProductCellDelegate
extension ProductViewController: ProductCellDelegate {

    func productCell(_ cell: ProductCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if isSearching {
            filteredProducts[indexPath.row].isFavorite.toggle()
            if let idx = products.firstIndex(where: { $0.id == filteredProducts[indexPath.row].id }) {
                products[idx].isFavorite = filteredProducts[indexPath.row].isFavorite
            }
        } else {
            products[indexPath.row].isFavorite.toggle()
        }

        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ProductViewController: SearchBarViewDelegate {
    func searchBarView(_ view: SearchBarView, didChangeText text: String) {
        searchText = text
        if text.isEmpty {
            filteredProducts = []
        } else {
            filteredProducts = products.filter {
                $0.name.localizedCaseInsensitiveContains(text) ||
                $0.category.localizedCaseInsensitiveContains(text)
            }
        }

        tableView.reloadData()
    }
    
    func searchBarViewDidBeginEditing(_ view: SearchBarView) {
           navigationItem.rightBarButtonItem = UIBarButtonItem(
               title: "Huỷ", style: .plain, target: self,
               action: #selector(cancelSearch)
           )
       }

       @objc private func cancelSearch() {
           searchBarView.searchTextField.resignFirstResponder()
           searchBarView.searchTextField.text = ""
           searchText = ""
           filteredProducts = []
           navigationItem.rightBarButtonItem = nil
           tableView.reloadData()
       }
}
