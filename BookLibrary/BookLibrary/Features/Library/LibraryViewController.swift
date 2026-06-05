//
//  LibraryViewController.swift
//  BookLibrary
//
//  Created by Văn Tiến on 01/06/2026.
//

import Combine
import UIKit

class LibraryViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!

  private var viewModel = LibraryViewModel()
  private var dataSource: UICollectionViewDiffableDataSource<Int, SavedBook>!
  private var cancellables = Set<AnyCancellable>()
  private var loadingIndicator = UIActivityIndicatorView(style: .medium)

  private let emptyLabel: UILabel = {
    let label = UILabel()
    label.text = "No saved books"
    label.textColor = .secondaryLabel
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    title = "Library"

    setupCollectionView()
    setupLoadingIndicator()
    setupEmptyLabel()
    configDataSource()
    bindViewModel()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    viewModel.fetchSavedBooks()
  }

  private func setupCollectionView() {
    collectionView.backgroundColor = .systemBackground
    collectionView.delegate = self
    collectionView.collectionViewLayout = makeLayout()
    collectionView.register(
      UINib(nibName: "LibraryBookViewCell", bundle: nil),
      forCellWithReuseIdentifier: "LibraryBookViewCell"
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

  private func setupLoadingIndicator() {
    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(loadingIndicator)

    NSLayoutConstraint.activate([
      loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingIndicator.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
    ])
  }

  private func setupEmptyLabel() {
    view.addSubview(emptyLabel)

    NSLayoutConstraint.activate([
      emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
      emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
    ])
  }

  private func configDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Int, SavedBook>(
      collectionView: collectionView
    ) { [weak self] collectionView, indexPath, savedBook in

      guard
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: "LibraryBookViewCell",
          for: indexPath
        ) as? LibraryBookViewCell
      else {
        return UICollectionViewCell()
      }

      cell.configure(with: savedBook)
      cell.onStateChange = { [weak self] book, _ in
        self?.viewModel.updateBook(book)
      }

      return cell
    }
  }

  private func applySnapshot(_ books: [SavedBook]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, SavedBook>()

    snapshot.appendSections([0])
    snapshot.appendItems(books, toSection: 0)

    dataSource.applySnapshotUsingReloadData(snapshot)
  }

  private func bindViewModel() {
    viewModel.$savedBooks
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
        guard let self else { return }

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
        guard let self else { return }

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
    guard !viewModel.isLoading else {
      emptyLabel.isHidden = true
      return
    }

    if viewModel.savedBooks.isEmpty {
      emptyLabel.text = "No saved books"
      emptyLabel.isHidden = false
      return
    }

    emptyLabel.isHidden = true
  }
}

extension LibraryViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let savedBook = dataSource.itemIdentifier(for: indexPath) else { return }

    let savedBookDetailVM = SavedBookDetailViewModel(savedBook: savedBook)
    let detailVC = SavedBookDetailViewController(viewModel: savedBookDetailVM)
    navigationController?.pushViewController(detailVC, animated: true)
  }
}
