//
//  CollectionViewController.swift
//  CollectionView
//
//  Created by Văn Tiến on 13/05/2026.
//

import UIKit

class CollectionViewController: UIViewController {

    var  users : [User] = User.getUser()
    var mainView = CollectionView()
    
    override func loadView() {
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collection View"
        setupBidings()
    }
    
    func setupBidings() {
        mainView.collectionView?.delegate = self
        mainView.collectionView?.dataSource = self
    }
}

extension CollectionViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.avataImage.image = UIImage(named: users[indexPath.row].avatar)
        cell.nameLabel.text = users[indexPath.row].name
        return cell
    }
    
    
}

extension CollectionViewController : UICollectionViewDelegate {
    
}
