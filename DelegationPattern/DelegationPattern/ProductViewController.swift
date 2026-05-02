//
//  ViewController.swift
//  DelegationPattern
//
//  Created by Văn Tiến on 01/05/2026.
//

import UIKit

class ProductViewController: UIViewController {

    
    
    @IBOutlet weak var tableView : UITableView!
    
    var products: [Product] = Product.sampleData
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
        }
    
}

extension ProductViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
       let product = products[indexPath.row]
       cell.configure(with: product)

       cell.delegate = self

       return cell
    }
}

extension ProductViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = products[indexPath.row]
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
        products.remove(at: indexPath.row)
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
        products[indexPath.row].isFavorite.toggle()

        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
