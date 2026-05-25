//
//  ViewController.swift
//  MVVM
//
//  Created by Văn Tiến on 21/05/2026.
//

import UIKit



class ViewController: UIViewController {
    
    private let viewModel: TodoListViewModel = TodoListViewModel()
    private weak var collectionView: UICollectionView!
    private weak var loadingView: UIActivityIndicatorView!
    private weak var emptyLabel: UILabel!
    private var dataSource : UICollectionViewDiffableDataSource<Section, Todo>!
    
    struct Section: Hashable {
        let id : Int
        var title: String
        func hash(into hasher: inout Hasher) {
          hasher.combine(id)
        }

        static func == (lhs: Section, rhs: Section) -> Bool {
          lhs.id == rhs.id
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupLoadingView()
        setupEmptyLabel()
        setupDataSource()
        
        bindViewModel()
        collectionView.delegate = self
        viewModel.loadTasks()
    }
    
    func setupCollectionView() {
        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout()
        )

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground

        collectionView.register(
            TodoCollectionViewCell.self,
            forCellWithReuseIdentifier: "todoCell"
        )
        
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )

        view.addSubview(collectionView)
        self.collectionView = collectionView
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
    }
    
    private func setupLoadingView() {
        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.hidesWhenStopped = true
        
        view.addSubview(loadingView)
        self.loadingView = loadingView
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupEmptyLabel() {
        let emptyLabel = UILabel()
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "Không có dữ liệu"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.numberOfLines = 0
        emptyLabel.isHidden = true
        
        view.addSubview(emptyLabel)
        self.emptyLabel = emptyLabel
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    //MARK: BINDING VIEWMODEL
    private func bindViewModel() {
           viewModel.state.bind { [weak self] state in
               self?.render(state)
           }
       }

       private func render(_ state: TaskListState) {
           switch state {
           case .idle:
               loadingView.stopAnimating()
               emptyLabel.isHidden = true

           case .loading:
               loadingView.startAnimating()
               emptyLabel.isHidden = true

           case .loaded(let todos):
               loadingView.stopAnimating()
               emptyLabel.isHidden = true
               self.applySnapshot(with: todos)

           case .empty:
               loadingView.stopAnimating()
               emptyLabel.isHidden = false
               self.applySnapshot(with: [])

           case .error(let message):
               loadingView.stopAnimating()
               emptyLabel.isHidden = true
               showAlert(message)
           }
       }

       private func showAlert(_ message: String) {
           let alert = UIAlertController(
               title: "Lỗi",
               message: message,
               preferredStyle: .alert
           )

           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
       }
    
//MARK: DIFFABLE DATASOURCE
    func  setupDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, Todo>(collectionView: collectionView) { collectionView, indexPath, item in
            switch indexPath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todoCell", for: indexPath) as! TodoCollectionViewCell
                cell.configure(with: item)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todoCell", for: indexPath) as! TodoCollectionViewCell
                cell.configure(with: item)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as! SectionHeaderView
            
            if let self = self {
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                headerView.configure(with: section.title)
            }
            
            return headerView
        }
    
    }
    func applySnapshot(with todoList: [[Todo]], animatedDifference: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Todo>()
        
        let sections = todoList.indices.map { index in
            Section(id: index, title: "Section \(index + 1)")
        }
        
        snapshot.appendSections(sections)
        
        for index in todoList.indices {
            let section = sections[index]
            let items = todoList[index]
            snapshot.appendItems(items, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatedDifference)
    }
//MARK: COMPOSITIONAL LAYOUT
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {[weak self] index , env in
            return self?.getLayout(index : index)
        }
        return layout
    }
    
    private func getLayout(index : Int) ->NSCollectionLayoutSection {
        switch index {
        case 0: return createSection(
                itemWidth: .fractionalWidth(1.0),
                itemHeight: .fractionalHeight(1.0),
                    groupWidth: .fractionalWidth(1.0),
                groupHeight: .absolute(200),
                interItemSpacing: 10,
                scrollBehaviour: .groupPagingCentered,
                headerHeight: .absolute(44)
            )
            
        case 1: return createSection(
                    itemWidth: .fractionalWidth(1/3),
                itemHeight: .fractionalHeight(1.0),
                groupWidth: .fractionalWidth(1.0),
                groupHeight: .absolute(100),
                interItemSpacing: 10,
                interGroupSpacing: 10,
                scrollBehaviour: .continuous,
                headerHeight: .absolute(44)
            )
            
        default:
            return createSection(
                itemWidth: .fractionalWidth(1.0 / 3.0),
                itemHeight: .fractionalHeight(1.0),
                groupWidth: .fractionalWidth(1.0),
                groupHeight: .absolute(100),
                interItemSpacing: 10,
                interGroupSpacing: 10,
                headerHeight: .absolute(44)
            )
        }
    }
    
    private func createSection(
        itemWidth: NSCollectionLayoutDimension,
        itemHeight: NSCollectionLayoutDimension,
        groupWidth: NSCollectionLayoutDimension,
        groupHeight: NSCollectionLayoutDimension,
        interItemSpacing : Double = 0 ,
        interGroupSpacing : Double = 0 ,
        scrollBehaviour: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none,
        sectionInset: NSDirectionalEdgeInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10),
        headerHeight: NSCollectionLayoutDimension? = nil
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.interItemSpacing = .fixed(interItemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = sectionInset
        section.orthogonalScrollingBehavior = scrollBehaviour
        
        if let headerHeight = headerHeight {
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: headerHeight
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
        }
        
        return section
    }
    //MARK: ADD TASK
    @objc private func didTapAddButton() {
           showTaskInputAlert(
               title: "Thêm task",
               taskTitle: nil,
               taskDescription: nil
           ) { [weak self] taskTitle, section in
               self?.viewModel.addTask(section: section, name: taskTitle)
           }
       }

       private func showTaskInputAlert(
           title: String,
           taskTitle: String?,
           taskDescription: String?,
           completion: @escaping (_ title: String, _ section: Int) -> Void
       ) {
           let alert = UIAlertController(
               title: title,
               message: nil,
               preferredStyle: .alert
           )

           alert.addTextField { textField in
               textField.placeholder = "Nhập title"
               textField.text = taskTitle
           }

           alert.addTextField { textField in
               textField.placeholder = "Section?"
               textField.text = taskDescription
           }

           let cancelAction = UIAlertAction(
               title: "Huỷ",
               style: .cancel
           )

           let saveAction = UIAlertAction(
               title: "Lưu",
               style: .default
           ) { _ in
               let title = alert.textFields?[0].text ?? ""
               let section = alert.textFields?[1].text ?? ""

               completion(title, Int(section) ?? 2)
           }

           alert.addAction(cancelAction)
           alert.addAction(saveAction)

           present(alert, animated: true)
       }

}

// MARK: COLLECTION VIEW DELEGATE
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVM = DetailViewModel(task: viewModel.todoList[indexPath.section][indexPath.item])
        let detailVC = DetailViewController(viewModel: detailVM)
        
        detailVC.onUpdatedTask = { [weak self] state in
            switch state {
            case .updatedTask(let updatedTask):
                self?.viewModel.updateTask(updatedTask, section: indexPath.section, itemIndex: indexPath.row)
            case .deletedTask(let deletedTask):
                self?.viewModel.removeTask(deletedTask, section: indexPath.section, index: indexPath.row)
                
            }
            
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
