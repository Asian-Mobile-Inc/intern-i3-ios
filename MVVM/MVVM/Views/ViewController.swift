//
//  ViewController.swift
//  MVVM
//
//  Created by Văn Tiến on 21/05/2026.
//

import UIKit



class ViewController: UIViewController {
    
    private let viewModel = TodoListViewModel()
    private var collectionView : UICollectionView!
    private var activityIndicator = UIActivityIndicatorView()
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
        setupDataSource()
        applySnapshot()
        
        bindViewModel()
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout()
        )

        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
    }
    
    func  setupDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch indexPath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "electronicCell", for: indexPath) as! ElectronicCollectionViewCell
                cell.configure(with: item)
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clothingCell", for: indexPath) as! ClothingCollectionViewCell
                cell.configure(with: item)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell
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
    func applySnapshot(){
        
    }
    func bindViewModel(){
        viewModel.onOutput = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .reloadData : self.collectionView.reloadData()
                
            case .error(let message) :
//                self.showAlert(message: message)
            }
        }
    }
    
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
}

