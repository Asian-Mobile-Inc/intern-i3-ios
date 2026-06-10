//
//  ViewController.swift
//  CoreData
//
//  Created by Văn Tiến on 28/05/2026.
//

import UIKit
import CoreData

//MARK: ENUM
enum TodoSortType {
    case newest
    case oldest
    case titleAZ
    case titleZA

    var title: String {
        switch self {
        case .newest:
            return "Mới nhất"
        case .oldest:
            return "Cũ nhất"
        case .titleAZ:
            return "A-Z"
        case .titleZA:
            return "Z-A"
        }
    }
}

enum TodoFilterType {
    case all
    case active
    case completed

    var title: String {
        switch self {
        case .all:
            return "Tất cả"
        case .active:
            return "Chưa xong"
        case .completed:
            return "Đã xong"
        }
    }
}

//MARK: VC
class ViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let controlBar = UIStackView()
    private let sortButton = UIButton(type: .system)
    private let filterButton = UIButton(type: .system)
    private var filterType: TodoFilterType = .all
    private var sortType: TodoSortType = .newest
    private var todos: [TodoEntity] = []

    private var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Todo List"

        setupTableView()
        setupControlBar()

        tableView.dataSource = self
        tableView.delegate = self

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        updateControlButtonTitles()

        fetchTodos()
    }
//MARK: SETUP UI
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseID)
        tableView.tableFooterView = UIView()

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupControlBar() {
        controlBar.axis = .horizontal
        controlBar.spacing = 12
        controlBar.distribution = .fillEqually
        controlBar.translatesAutoresizingMaskIntoConstraints = false

        configureControlButton(sortButton, action: #selector(sortButtonTapped))
        configureControlButton(filterButton, action: #selector(filterButtonTapped))

        controlBar.addArrangedSubview(sortButton)
        controlBar.addArrangedSubview(filterButton)
        view.addSubview(controlBar)

        NSLayoutConstraint.activate([
            controlBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            controlBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            controlBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            controlBar.heightAnchor.constraint(equalToConstant: 36),

            tableView.topAnchor.constraint(equalTo: controlBar.bottomAnchor, constant: 8)
        ])
    }

    private func configureControlButton(_ button: UIButton, action: Selector) {
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 8
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: action, for: .touchUpInside)
    }

    private func updateControlButtonTitles() {
        sortButton.setTitle("Sort: \(sortType.title)", for: .normal)
        filterButton.setTitle("Filter: \(filterType.title)", for: .normal)
    }
    
    // MARK: SETUP SORT & PREDIACTE
    private func fetchTodos() {
        let request : NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        switch filterType {
        case .all:
            request.predicate = nil
        case .active:
            request.predicate = NSPredicate(format: "isDone == %@", NSNumber(value: false))
        case .completed:
            request.predicate = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        }
        
        switch sortType {
        case .newest:
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        case .oldest:
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        case .titleAZ:
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        case .titleZA:
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        }
        
        do {
            todos = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Fetch Failed", error)
        }
    }
    //MARK: ADD BUTTON
    @objc private func addButtonTapped() {
        let alert = UIAlertController(title: "Add", message: "Enter task", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter title"
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            let title = alert.textFields?.first?.text ?? ""
            
            if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return
            }
            self.createTodo(title: title)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present( alert, animated:  true)
    }

    //MARK: SORT BUTTON
    @objc private func sortButtonTapped() {
        let alert = UIAlertController(title: "Sort", message: "Choose sort type", preferredStyle: .actionSheet)
        
        let options : [TodoSortType] = [.newest, .oldest, .titleAZ, .titleZA]
        
        for option in options {
            let isCurrent = option == sortType
            let actionTitle = isCurrent ? "✓ \(option.title)" : option.title
            let alertAction = UIAlertAction(title: actionTitle, style: .default) { [weak self] _ in
                guard let self = self else {return}
                self.sortType = option
                self.updateControlButtonTitles()
                self.fetchTodos()
            }
            alert.addAction(alertAction)
        }
        present(alert, animated: true)
    }
    //MARK: FILTER BUTTON
    @objc private func filterButtonTapped() {
        let alert = UIAlertController(title: "Filter", message: "Choose filter type", preferredStyle: .actionSheet)
        
        let options : [TodoFilterType] = [.all, .active, .completed]
        
        for option in options {
            let isCurrent = option == filterType
            let actionTitle = isCurrent ? "✓ \(option.title)" : option.title
            let alertAction = UIAlertAction(title: actionTitle, style: .default) { [weak self] _ in
                guard let self = self else {return}
                self.filterType = option
                self.updateControlButtonTitles()
                self.fetchTodos()
            }
            alert.addAction(alertAction)
        }
        
        present(alert, animated: true)
    }
    
    //MARK: POPUP UI
    private func createTodo(title: String) {
        let todo = TodoEntity(context: context)
        
        todo.id = UUID()
        todo.title = title
        todo.isDone = false
        todo.createdAt = Date()
        saveContext()
        fetchTodos()
    }
    
    private func saveContext() {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Save context failed", error)
        }
    }
    
    
    private func showEditAlert(at indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        let alert = UIAlertController(title: "Update", message: "", preferredStyle: .actionSheet)
        
        alert.addTextField { textField in
            textField.text = todo.title
            
        }
        
        let editAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self else {return}
            let title = alert.textFields?.first?.text ?? ""
            if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return
            }
            todo.title = title
            self.saveContext()
            self.fetchTodos()
        }
        alert.addAction(editAction)
        present(alert, animated: true)
    }
    
    private func deleteTodo(at indexPath: IndexPath) {
        let todo = todos[indexPath.row]

        context.delete(todo)

        saveContext()
        fetchTodos()
    }
}

//MARK: TABLE VIEW DELEGATE & DATA SOURCE
extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoCell.reuseID,
            for: indexPath
        ) as? TodoCell else {
            return UITableViewCell()
        }

        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        cell.onTapRadioButton = { [weak self, weak tableView, weak cell] in
            guard
                let self = self,
                let tableView = tableView,
                let cell = cell,
                let tappedIndexPath = tableView.indexPath(for: cell)
            else { return }

            let tappedTodo = self.todos[tappedIndexPath.row]
            tappedTodo.isDone.toggle()
            self.saveContext()
            self.fetchTodos()
        }

        return cell
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(
            _ tableView: UITableView,
            didSelectRowAt indexPath: IndexPath
        ) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Xóa"
        ) { [weak self] _, _, completion in
            self?.deleteTodo(at: indexPath)
            completion(true)
        }

        let editAction = UIContextualAction(
            style: .normal,
            title: "Sửa"
        ) { [weak self] _, _, completion in
            self?.showEditAlert(at: indexPath)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
