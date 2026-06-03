//
//  SearchViewController.swift
//  BookLibrary
//
//  Created by Văn Tiến on 01/06/2026.
//

import UIKit
import Combine
class SearchViewController: UIViewController {
    private let defaultEmptyMessage = "Search books by name, author..."

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBarView: SearchBarView!
    
    private var viewModel = SearchViewModel()
    private var dataSource : UICollectionViewDiffableDataSource<Int, Book>!
    private var cancellables = Set<AnyCancellable>()
    private var loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    private let emptyLabel: UILabel = {
       let label = UILabel()
       label.text = "Search books by name, author..."
       label.textColor = .secondaryLabel
       label.textAlignment = .center
       label.numberOfLines = 0
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search Books"
        setupCollectionView()
        setupLoadingIndicator()
        setupEmptyLabel()
        configDataSource()
        bindViewModel()
        updateEmptyState()
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemBackground
//        collectionView.delegate = self
        collectionView.collectionViewLayout = makeLayout()
        collectionView.register(
            UINib(nibName: "BookViewCell", bundle: nil),
            forCellWithReuseIdentifier: "BookViewCell"
        )
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
               )
           
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
           top: 6,
           leading: 6,
           bottom: 6,
           trailing: 6
        )

        let groupSize = NSCollectionLayoutSize(
           widthDimension: .fractionalWidth(1.0),
           heightDimension: .absolute(180)
        )

        let group = NSCollectionLayoutGroup.horizontal(
           layoutSize: groupSize,
           subitems: [item, item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
           top: 8,
           leading: 10,
           bottom: 24,
           trailing: 10
        )

        return UICollectionViewCompositionalLayout(section: section)
        
    }

    func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 24)
        ])
    }
    
    func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    
    //  MARK: CONFIG DATASOURCE
    private func configDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Int, Book>(
               collectionView: collectionView
           ) { collectionView, indexPath, book in
               
               guard let cell = collectionView.dequeueReusableCell(
                   withReuseIdentifier: "BookViewCell",
                   for: indexPath
               ) as? BookViewCell else {
                   return UICollectionViewCell()
               }
               
               cell.configure(with: book)
               return cell
           }
    }
    
    func applySnapshot(_ books : [Book]) {
        var snapShort = NSDiffableDataSourceSnapshot<Int, Book>()
        
        snapShort.appendSections([0])
        snapShort.appendItems(books, toSection: 0)
        
        dataSource.apply(snapShort)
    }

    //MARK: BIND VIEW MODEL
    func bindViewModel () {
        searchBarView.textPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.viewModel.searchText = text
            }
            .store(in: &cancellables)
        
        viewModel.$books
            .receive(on: DispatchQueue.main)
            .sink { [weak self] books in
                guard let self else { return }
                
                self.applySnapshot(books)
                self.updateEmptyState()
            }
            .store(in: &cancellables)
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.loadingIndicator.startAnimating()
                    self.emptyLabel.isHidden = true
                } else {
                    self.loadingIndicator.stopAnimating()
                    self.updateEmptyState()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                
                if let errorMessage {
                    self.emptyLabel.text = errorMessage
                    self.emptyLabel.isHidden = false
                } else {
                    self.updateEmptyState()
                }
            }
            .store(in: &cancellables)
    }

    private func updateEmptyState() {
        let trimmedSearchText = viewModel.searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !viewModel.isLoading else {
            emptyLabel.isHidden = true
            return
        }
        
        if trimmedSearchText.isEmpty {
            emptyLabel.text = defaultEmptyMessage
            emptyLabel.isHidden = false
            return
        }
        
        if viewModel.books.isEmpty {
            emptyLabel.text = "No books found"
            emptyLabel.isHidden = false
            return
        }
        
        emptyLabel.isHidden = true
    }
}
