import UIKit

final class ViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Todo List"
        setupTableView()
        bindViewModel()
        Task {
           await viewModel.fetchData()
        }
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseID)

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func bindViewModel() {
        viewModel.onOutput = { [weak self] result in
            switch result {
            case .success(let message) :
                print(message)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.reuseID, for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        let todo = viewModel.todos[indexPath.row]
        cell.configure(with: todo)
        cell.onTapRadio = { [weak self] in
            guard let self else { return }
            viewModel.todos[indexPath.row].completed.toggle()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
