//
//  CompositionalDSViewController.swift
//  CollectionView
//
//  Created by Văn Tiến on 18/05/2026.
//

import UIKit

class CompositionalDSViewController: UIViewController {
    
    private let collectionView : UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    private var sectionDataSource : [[UIColor]] = [
        [.yellow, .yellow, .yellow],
        [.systemBlue, .systemBlue, .systemBlue, .systemBlue],
        [.systemGreen, .systemGreen, .systemGreen, .systemGreen, .systemGreen,]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        setupCollectionVIew()
        // Do any additional setup after loading the view.
    }
    func createView(){
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    private func setupCollectionVIew() {
        registerCell()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
    }
    func registerCell() {
        collectionView.register(CompositionalDSViewCell.self, forCellWithReuseIdentifier: CompositionalDSViewCell.self.description())
        collectionView.register(HeaderViewCell.self, forSupplementaryViewOfKind: HeaderViewCell.self.description(), withReuseIdentifier: HeaderViewCell.self.description())
        collectionView.register(FooterViewCell.self, forSupplementaryViewOfKind: FooterViewCell.self.description(), withReuseIdentifier: FooterViewCell.self.description())
    }

}

extension CompositionalDSViewController : UICollectionViewDelegate {
    
}
 // MARK: DataSource
extension CompositionalDSViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView : UICollectionView) -> Int {
        return sectionDataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionDataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalDSViewCell.self.description(), for: indexPath) as! CompositionalDSViewCell
        cell.backgroundColor = sectionDataSource[indexPath.section][indexPath.item]
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    
}

extension CompositionalDSViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] index, env in
            return self?.getLayout(for : index)
        }
        return layout
    }
    
    func getLayout(for index : Int) -> NSCollectionLayoutSection {
        switch index {
        case 0: return createSection(
                    itemWidth: .fractionalWidth(1.0),
                    itemHeight: .fractionalHeight(1.0),
                    groupWidth: .fractionalWidth(1.0),
                    groupHeight: .absolute(200),
                    interItemSpacing: 10,
                    scrollBehaviour: .groupPagingCentered,
                    
        )
            
        case 1: return createSection(
                    itemWidth: .fractionalWidth(1/3),
                    itemHeight: .fractionalHeight(1.0),
                    groupWidth: .fractionalWidth(1.0),
                    groupHeight: .absolute(100),
                    interItemSpacing: 10,
                    interGroupSpacing: 10,
                    scrollBehaviour: .continuous
        )
        case 2: return createSection(
                    itemWidth: .fractionalWidth(1/3),
                    itemHeight: .fractionalHeight(1.0),
                    groupWidth: .fractionalWidth(1.0),
                    groupHeight: .absolute(100),
                    interItemSpacing: 10,
                    interGroupSpacing: 10,
                    headerHeight: .absolute(50)
                    )
        default: break
        }
        return createEmptySection()
    }
    
    func createSection(
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
                section.orthogonalScrollingBehavior = scrollBehaviour
                section.contentInsets = sectionInset
                section.boundarySupplementaryItems = []
                if let headerHeight = headerHeight {
                    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: headerHeight)
                    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HeaderViewCell.self.description(), alignment: .top)
                    section.boundarySupplementaryItems.append(header)
                }
        return section
    }
    
    private func createEmptySection(height: CGFloat = 0 ) -> NSCollectionLayoutSection {
        return createSection(itemWidth: .fractionalWidth(1.0), itemHeight: .absolute(height), groupWidth: .fractionalWidth(1.0), groupHeight: .absolute(height))
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == HeaderViewCell.self.description() {
            let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderViewCell.self.description(), withReuseIdentifier: HeaderViewCell.self.description(), for: indexPath)
            headerCell.backgroundColor = .gray
            return headerCell
        }
        else if kind == FooterViewCell.self.description() {
            let footerCell = collectionView.dequeueReusableSupplementaryView(ofKind: FooterViewCell.self.description(), withReuseIdentifier: FooterViewCell.self.description(), for: indexPath)
            footerCell.backgroundColor = .white
        }
        return UICollectionReusableView()
    }
}
