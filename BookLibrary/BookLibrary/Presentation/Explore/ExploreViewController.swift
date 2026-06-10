//
//  ExploreViewController.swift
//  BookLibrary
//
//  Created by Văn Tiến on 01/06/2026.
//

import Combine
import UIKit

class ExploreViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  private let makeBookDetailViewController: @MainActor (Book) -> BookDetailViewController
  private struct ExploreItem: Hashable {
    let section: ExploreSection
    let book: Book

    func hash(into hasher: inout Hasher) {
      hasher.combine(section)
      hasher.combine(book.id)
    }

    static func == (lhs: ExploreItem, rhs: ExploreItem) -> Bool {
      lhs.section == rhs.section && lhs.book.id == rhs.book.id
    }
  }

  private var dataSource: UICollectionViewDiffableDataSource<ExploreSection, ExploreItem>!
  private let viewModel: ExploreViewModel
  private var cancellables = Set<AnyCancellable>()
    private var loadingIndicator = UIActivityIndicatorView(style: .large)

  init(
    viewModel: ExploreViewModel,
    makeBookDetailViewController: @escaping @MainActor (Book) -> BookDetailViewController
  ) {
    self.viewModel = viewModel
    self.makeBookDetailViewController = makeBookDetailViewController
    super.init(nibName: "ExploreViewController", bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "Explore"
    setupCollectionView()
    setupLoadingIndicator()
    setupDataSource()
    bindViewModel()

    viewModel.fetchData()
  }

  private func setupCollectionView() {
    collectionView.backgroundColor = .systemBackground
    collectionView.collectionViewLayout = createLayout()
    collectionView.delegate = self
    collectionView.register(
      UINib(nibName: "BookExploreViewCell", bundle: nil),
      forCellWithReuseIdentifier: "bookExploreViewCell"
    )

    collectionView.register(
      SectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: SectionHeaderView.reuseIdentifier
    )

  }

  private func setupLoadingIndicator() {
    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(loadingIndicator)

    NSLayoutConstraint.activate([
      loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingIndicator.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 24
      ),
    ])
  }

  private func bindViewModel() {
    viewModel.$sections
      .receive(on: DispatchQueue.main)
      .sink { [weak self] sections in
        self?.applySnapshot(sections)
      }
      .store(in: &cancellables)

    viewModel.$isLoading
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isLoading in
        guard let self else { return }

        if isLoading {
          self.loadingIndicator.startAnimating()
        } else {
          self.loadingIndicator.stopAnimating()
        }
      }
      .store(in: &cancellables)
  }

  //MARK: COMPOSITIONAL LAYOUT
  private func createLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { [weak self] index, env in
      return self?.getLayout(index: index)
    }
    return layout
  }
  private func getLayout(index: Int) -> NSCollectionLayoutSection {
    switch index {
    case 0:
      return createSection(
        itemWidth: .fractionalWidth(1.0),
        itemHeight: .fractionalHeight(1.0),
        groupWidth: .fractionalWidth(1.0),
        groupHeight: .absolute(200),
        interItemSpacing: 10,
        interGroupSpacing: 10,
        scrollBehaviour: .groupPagingCentered,
        headerHeight: .absolute(44)
      )

    case 1:
      return createSection(
        itemWidth: .fractionalWidth(1.0),
        itemHeight: .fractionalHeight(1.0),
        groupWidth: .fractionalWidth(2 / 3.0),
        groupHeight: .absolute(200),
        interItemSpacing: 10,
        interGroupSpacing: 10,
        scrollBehaviour: .continuous,
        headerHeight: .absolute(44)
      )

    default:
      return createSection(
        itemWidth: .fractionalWidth(1 / 2.0),
        itemHeight: .fractionalHeight(1.0),
        groupWidth: .fractionalWidth(1.0),
        groupHeight: .absolute(200),
        itemsPerGroup: 2,
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
    itemsPerGroup: Int = 1,
    interItemSpacing: Double = 0,
    interGroupSpacing: Double = 0,
    scrollBehaviour: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none,
    sectionInset: NSDirectionalEdgeInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10),
    headerHeight: NSCollectionLayoutDimension? = nil
  ) -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize, subitem: item, count: itemsPerGroup)

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

  //MARK: DIFFABLE DATASOURCE
  private func setupDataSource() {
    dataSource = UICollectionViewDiffableDataSource<ExploreSection, ExploreItem>(
      collectionView: collectionView
    ) { collectionView, indexPath, item in
      guard
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: "bookExploreViewCell",
          for: indexPath
        ) as? BookExploreViewCell
      else {
        return UICollectionViewCell()
      }

      cell.configure(with: item.book)
      return cell
    }

    dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
      guard kind == UICollectionView.elementKindSectionHeader else { return nil }

      guard
        let headerView = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: SectionHeaderView.reuseIdentifier,
          for: indexPath
        ) as? SectionHeaderView,
        let self
      else {
        return nil
      }

      let sections = self.dataSource.snapshot().sectionIdentifiers
      guard sections.indices.contains(indexPath.section) else {
        return headerView
      }

      let section = sections[indexPath.section]
      headerView.configure(with: section.title)
      return headerView
    }

  }

  func applySnapshot(_ sections: [ExploreSection: [Book]]) {
    var snapshot = NSDiffableDataSourceSnapshot<ExploreSection, ExploreItem>()

    for section in ExploreSection.allCases {
      guard let books = sections[section], !books.isEmpty else {
        continue
      }

      let items = books.map { ExploreItem(section: section, book: $0) }
      snapshot.appendSections([section])
      snapshot.appendItems(items, toSection: section)
    }

    dataSource.apply(snapshot, animatingDifferences: true)
  }

}

//MARK: DELEGATE

extension ExploreViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let book = dataSource.itemIdentifier(for: indexPath) else { return }

    let detailVC = makeBookDetailViewController(book.book)

    navigationController?.pushViewController(detailVC, animated: true)
  }
}
